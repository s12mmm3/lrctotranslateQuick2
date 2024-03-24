import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Dialogs

ApplicationWindow  {
    width: 400
    height: 300
    visible: true
    title: qsTr("翻译打轴")
    FileDialog {
        property string content: ""
        id: fileDialog_save
        title: "另存为"
        nameFilters: ["Text files (*.txt)", "Lyric file (*.lrc)"]
        acceptLabel: "确定"
        rejectLabel: "取消"
        fileMode: FileDialog.SaveFile
        onAccepted: {
            $operateMgr.saveFile(currentFile, content)
        }
    }
    menuBar: MenuBar {
        Menu {
            title: qsTr("项目")
            MenuItem {
                text: "新建"
                onClicked: {
                    if(textArea_lrc.text !== "" || textArea_trans.text !== "") {
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
                        if(button === MessageDialog.Ok) {
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
                    fileDialog_lrc.open()
                }
                FileDialog {
                    id: fileDialog_lrc
                    title: "打开txt、lrc文件"
                    nameFilters: ["Text files (*.txt)", "Lyric file (*.lrc)"]
                    acceptLabel: "确定"
                    rejectLabel: "取消"
                    fileMode: FileDialog.OpenFile
                    onAccepted: {
                        textArea_lrc.text = $operateMgr.readFile(currentFile)
                    }
                }
            }
            MenuItem {
                text: "打开翻译文本"
                onClicked: {
                    fileDialog_trans.open()
                }
                FileDialog {
                    id: fileDialog_trans
                    title: "打开txt、lrc文件"
                    nameFilters: ["Text files (*.txt)", "Lyric file (*.lrc)"]
                    acceptLabel: "确定"
                    rejectLabel: "取消"
                    fileMode: FileDialog.OpenFile
                    onAccepted: {
                        textArea_trans.text = $operateMgr.readFile(currentFile)
                    }
                }
            }
            MenuItem {
                text: "歌词另存为"
                onClicked: {
                    fileDialog_save.content = textArea_lrc.text
                    fileDialog_save.open()
                }
            }
            MenuItem {
                text: "翻译另存为"
                onClicked: {
                    fileDialog_save.content = textArea_trans.text
                    fileDialog_save.open()
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
            title: qsTr("歌词")
            MenuItem {
                text: "撤销"
                enabled: !root.isPreview && textArea_lrc.canUndo
                onClicked: {
                    textArea_lrc.undo()
                }
            }
            MenuItem {
                text: "恢复"
                enabled: !root.isPreview && textArea_lrc.canRedo
                onClicked: {
                    textArea_lrc.redo()
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "剪贴"
                onClicked: {
                    textArea_lrc.cut()
                }
            }
            MenuItem {
                text: "复制"
                onClicked: {
                    textArea_lrc.copy()
                }
            }
            MenuItem {
                text: "粘贴"
                enabled: !root.isPreview && textArea_lrc.canPaste
                onClicked: {
                    textArea_lrc.paste()
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "全选"
                onClicked: {
                    textArea_lrc.selectAll()
                }
            }
            MenuItem {
                text: "清空"
                enabled: !root.isPreview
                onClicked: {
                    textArea_lrc.clear()
                }
            }
        }
        Menu {
            title: qsTr("翻译")
            MenuItem {
                text: "撤销"
                enabled: !root.isPreview && textArea_trans.canUndo
                onClicked: {
                    textArea_trans.undo()
                }
            }
            MenuItem {
                text: "恢复"
                enabled: !root.isPreview && textArea_trans.canRedo
                onClicked: {
                    textArea_trans.redo()
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "剪贴"
                onClicked: {
                    textArea_trans.cut()
                }
            }
            MenuItem {
                text: "复制"
                onClicked: {
                    textArea_trans.copy()
                }
            }
            MenuItem {
                text: "粘贴"
                enabled: !root.isPreview && textArea_trans.canPaste
                onClicked: {
                    textArea_trans.paste()
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "全选"
                onClicked: {
                    textArea_trans.selectAll()
                }
            }
            MenuItem {
                text: "清空"
                enabled: !root.isPreview
                onClicked: {
                    textArea_trans.clear()
                }
            }
        }
        Menu {
            title: qsTr("帮助")
            MenuItem {
                text: "关于"
                onClicked: {
                    messageDialog_about.detailedText = $operateMgr.getDetail()
                    messageDialog_about.open()
                }
                MessageDialog {
                    id: messageDialog_about
                    modality: Qt.ApplicationModal
                    title: "关于"
                    text: "本程序用于处理歌词与翻译的时间轴"
                    informativeText: "作者:舰长的初号\nid:257800231"
                    onButtonClicked: function(button) {
                        if(button === MessageDialog.Ok) {
                            close()
                        }
                    }
                }
            }
        }
    }
    Column {
        anchors.fill: parent
        spacing: 4
        id: root
        property bool isPreview: false

        property bool lock: true //用于两个滚动条的互斥锁
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
            height: parent.height - row0.height - row2.height
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

                TextAreaNormal {
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

                TextAreaNormal {
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

        Item {
            id: row2
            height: 50
            width: parent.width
            Button {
                anchors.right: parent.right
                anchors.rightMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                text: root.isPreview ? "退出预览" : "预览"
                onClicked: {
                    root.isPreview = !(root.isPreview)
                    root.process()
                }
            }

            CheckBox {
                id: checkBox
                anchors.left: parent.left
                anchors.leftMargin: 5
                anchors.verticalCenter: parent.verticalCenter
                checked: false
                text: "合并为一句"
            }
        }

        function process() {
            if(isPreview) {
                root.textBackup = textArea_trans.text
                let lrcList = textArea_lrc.text.split("\n")
                let transList = textArea_trans.text.split("\n")
                let result = ""
                for(let i = 0; i < Math.max(lrcList.length, transList.length); ++i) {
                    if(i < lrcList.length) {
                        if(lrcList[i].indexOf("[") !== -1 && lrcList[i].indexOf("]") !== -1) {
                            if(checkBox.checkState !== Qt.Checked) {
                                result = result + lrcList[i].substring(lrcList[i].indexOf("["),lrcList[i].indexOf("]") + 1)
                            }
                            else result += (lrcList[i]+" ")
                        }
                    }
                    if(i < transList.length) {
                        result += transList[i]
                    }
                    result += "\n"
                }
                textArea_trans.clear()
                textArea_trans.append(result)
            }
            else {
                textArea_trans.clear()
                textArea_trans.append(root.textBackup)
            }
        }
    }
}
