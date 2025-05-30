﻿import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow  {
    width: 1280
    height: 720
    visible: true
    title: qsTr("翻译打轴")
    id: root
    property bool isPreview: false
    property bool lock: true //用于两个滚动条的互斥锁
    property string textBackup
    function saveTextToFile(callback) {
        fileDialog_save.callback = callback
        fileDialog_save.open()
    }
    FileDialog {
        property var callback: undefined
        id: fileDialog_save
        nameFilters: ["Text files (*.txt)", "Lyric file (*.lrc)"]
        fileMode: FileDialog.SaveFile
        onAccepted: { if (callback) callback(currentFile) }
    }

    function getTextFromFile(callback) {
        fileDialog_open.callback = callback
        fileDialog_open.open()
    }
    FileDialog {
        property var callback: undefined
        id: fileDialog_open
        nameFilters: [ "Text files (*.txt *.lrc)", ]
        fileMode: FileDialog.OpenFile
        onAccepted: { if (callback) callback(currentFile) }
    }
    menuBar: MenuBar {
        Menu {
            title: qsTr("项目")
            MenuItem {
                text: "新建"
                onClicked: {
                    if (textArea_lrc.text || textArea_trans.text) {
                        messageDialog_new.open()
                    }
                }
                MessageDialog {
                    id: messageDialog_new
                    title: "提示"
                    buttons: MessageDialog.Ok | MessageDialog.Cancel
                    text: "歌词或翻译不为空"
                    informativeText: "是否清空？"
                    onButtonClicked: {
                        if (button === MessageDialog.Ok) {
                            textArea_lrc.text = ""
                            textArea_trans.text = ""
                            root.isPreview = false
                        }
                        close()
                    }
                }
            }
            MenuItem {
                text: "打开歌词文本"
                onClicked: {
                    getTextFromFile((currentFile) => textArea_lrc.text = $operator.readFile(currentFile))
                }
            }
            MenuItem {
                text: "打开翻译文本"
                onClicked: {
                    getTextFromFile((currentFile) => textArea_trans.text = $operator.readFile(currentFile))
                }
            }
            MenuItem {
                text: "歌词另存为"
                onClicked: {
                    saveTextToFile((currentFile) => $operator.saveFile(currentFile, textArea_lrc.text))
                }
            }
            MenuItem {
                text: "翻译另存为"
                onClicked: {
                    saveTextToFile((currentFile) => $operator.saveFile(currentFile, textArea_trans.text))
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "退出"
                onClicked: {
                    Qt.quit()
                }
            }
        }
        Menu {
            title: qsTr("帮助")
            MenuItem {
                text: "关于"
                onClicked: {
                    messageDialog_about.open()
                }
            }
        }
    }
    MessageDialog {
        property var detail: $operator.getDetail()
        id: messageDialog_about
        title: "关于"
        text: "本程序用于处理歌词与翻译的时间轴"
        informativeText: "作者:舰长的初号\nid:257800231"
        detailedText: ("基于Qt%1编译\n编译时间:%2\n系统:%3")
        .arg(detail.QT_VERSION_STR)
        .arg(detail.__DATE__)
        .arg(detail.prettyProductName)
        onButtonClicked: function(button) {
            if (button === MessageDialog.Ok) {
                close()
            }
        }
    }
    Column {
        anchors.fill: parent
        spacing: 4
        Row {
            id: row0
            width: parent.width
            Text {
                width: parent.width / 2
                text: "歌词"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
            Text {
                width: parent.width / 2
                text: "翻译"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }

        Row {
            width: parent.width
            height: parent.height - row0.height
            ScrollView {
                width: parent.width / 2
                height: parent.height
                ScrollBar.vertical: ScrollBar {
                    id: scrollBar1
                    parent: parent
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    onPositionChanged: {
                        if(root.lock) {
                            root.lock = false
                            scrollBar2.position = ((textArea_lrc.lineCount * 1.0) / (textArea_trans.lineCount * 1.0))
                                    * scrollBar1.position
                            root.lock = true
                        }
                    }
                }

                TextArea {
                    id: textArea_lrc
                }
            }
            ScrollView {
                width: parent.width / 2
                height: parent.height
                ScrollBar.vertical: ScrollBar {
                    id: scrollBar2
                    parent: parent
                    anchors.top: parent.top
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom

                    onPositionChanged: {
                        if(root.lock) {
                            root.lock = false
                            scrollBar1.position = ((textArea_trans.lineCount * 1.0) / (textArea_lrc.lineCount * 1.0))
                                    * scrollBar2.position
                            root.lock = true
                        }
                    }
                }

                TextArea {
                    id: textArea_trans
                    Rectangle {
                        //Background
                        anchors.fill: parent
                        opacity: 0.2
                        color: "grey"
                        visible: root.isPreview
                    }

                }
            }
        }
    }
    footer: DialogButtonBox {
        CheckBox {
            id: checkBox
            checked: false
            text: "合并为一句"
        }

        ToolButton {
            text: root.isPreview ? "退出预览" : "预览"
            onClicked: {
                root.isPreview = !(root.isPreview)
                root.process()
            }
        }
    }

    function process() {
        if (isPreview) {
            root.textBackup = textArea_trans.text
            const lrcLines = textArea_lrc.text.split("\n")
            const transLines = textArea_trans.text.split("\n")
            let result = ""
            for (let i = 0; i < Math.max(lrcLines.length, transLines.length); i++) {
                if (i < lrcLines.length && lrcLines[i].includes("[") && lrcLines[i].includes("]")) {
                    result += checkBox.checked
                        ? `${lrcLines[i]} `
                        : lrcLines[i].slice(lrcLines[i].indexOf("["), lrcLines[i].indexOf("]") + 1)
                }
                if (i < transLines.length) result += transLines[i]
                result += "\n"
            }
            textArea_trans.text = result
        } else {
            textArea_trans.text = root.textBackup
        }
    }
}
