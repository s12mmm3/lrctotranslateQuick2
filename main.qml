import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
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
            $operateMgr.saveFile(currentFile,content)
        }
    }
    menuBar: MenuBar {
        Menu {
            title: qsTr("项目")
            MenuItem {
                text: "新建"
                onClicked: {
                    if(root.textArea_lrc.text !== "" || root.textArea_trans.text !== "") {
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
                            root.textArea_lrc.text = ""
                            root.textArea_trans.text = ""
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
                        root.textArea_lrc.text = $operateMgr.readFile(currentFile)
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
                        root.textArea_trans.text = $operateMgr.readFile(currentFile)
                    }
                }
            }
            MenuItem {
                text: "歌词另存为"
                onClicked: {
                    fileDialog_save.content = root.textArea_lrc.text
                    fileDialog_save.open()
                }
            }
            MenuItem {
                text: "翻译另存为"
                onClicked: {
                    fileDialog_save.content = root.textArea_trans.text
                    fileDialog_save.open()
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "退出"
                onClicked: {
                    root.saveBackup()
//                    Qt.exit(0)
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
                text: "示例(by 弓野篤禎_Simon)"
                enabled: !root.isPreview
                onClicked: {
                    if(root.textArea_lrc.text !== "" || root.textArea_trans.text !== "") {
                        messageDialog_sample.open()
                    }
                    else messageDialog_sample.sampleShow()
                }
                MessageDialog {
                    id: messageDialog_sample
                    title: "提示"
                    buttons: MessageDialog.Ok | MessageDialog.Cancel
                    text: "歌词或翻译不为空"
                    informativeText: "是否覆盖？"
                    onButtonClicked: {
                        if(button === MessageDialog.Ok) {
                            sampleShow()
                        }
                        close()
                    }
                    function sampleShow() {
                        root.textArea_lrc.clear()
                        root.textArea_lrc.append(textLrc)
                        root.textArea_trans.clear()
                        root.textArea_trans.append(textTrans)
                    }

                    property string textLrc: {
                        return "[00:30.64]ヘッドホン外して
[00:33.19]一人きり　歩く街
[00:36.17]迷っているのか
[00:37.44]間違っているのか
[00:40.04]知らない場所みたいだ
[00:43.22]
[00:44.27]見えない信仰心
[00:46.02]感じないシンパシー
[00:47.73]俺にはないものばかりだ
[00:51.14]なんのストーリー？
[00:52.87]だれのストーリー？
[00:54.59]手に入んなきゃ欲しくなる
[00:56.93]そうだろ
[00:58.35]
[00:58.57]合図くれよ
[01:00.42]マイクかざせ
[01:02.12]あいつは今
[01:03.85]追い風になびいていく
[01:07.27]チャンスはきた
[01:08.96]ダイブすんぜHATER!
[01:11.79]
[01:11.80]今リスタートキメて　はじめて
[01:15.15]“みたい”
[01:15.81]ただそれだけでいいでしょ
[01:19.17]理由なんて知らない
[01:20.96]理由なんていらない
[01:22.87]運命　ルールに抗って
[01:25.38]
[01:25.39]今リスタートキメて　弾けて
[01:28.92]“見たい”
[01:29.52]ただそれだけでいいでしょ
[01:32.93]打ち鳴らせGroovy
[01:34.68]聴かせてよHeart Beat
[01:36.49]立ち止まる暇なんてないから
[01:40.62]
[01:52.82]Hey Yo!
[01:53.46]アーアーマイクチェックワンツー
[01:55.36]All Nightでも案外余裕～
[01:57.13]とか言うお前マジで女優(笑)
[01:58.66]上流階級？なら物申す！
[02:00.30]
[02:00.31]RADでBADなUNDER DOGが
[02:02.04]ビビッときたね　VIVIDに染まれ
[02:03.82]上しかみてねえ
[02:04.70]今日のオマエは
[02:05.59]秘める闘志の悩める勝ち犬
[02:07.98]
[02:20.89]合図くれよ
[02:22.66]マイクかざせ
[02:24.38]俺らは今
[02:26.13]追い風になびいていく
[02:29.51]チャンスはきた
[02:31.26]ダイブすんぜHATER!
[02:34.72]
[02:35.50]今リスタートキメて　はじめて
[02:39.13]“みたい”
[02:39.70]ただそれだけでいいでしょ
[02:43.19]理由なんて知らない
[02:44.93]理由なんていらない
[02:46.81]背徳の快感　味わって
[02:49.34]
[02:49.35]今リスタートキメて　弾けて
[02:52.88]“見たい”
[02:53.51]ただそれだけでいいでしょ
[02:56.95]打ち鳴らせGroovy
[02:58.62]聴かせてよHeart Beat
[03:00.45]立ち止まる暇なんてないから
[03:06.54]
[03:06.55]追い風に吹かれて
[03:14.16]Alright　振り向かず
[03:16.49]進んで
[03:18.47]"
                    }
                    property string textTrans: {
                        return "将头戴耳机  挂上颈
一人独自 沿街行
我这是迷失了吗？
是在哪里搞错了吗？
似乎到了不曾见的地方

看不见的 信仰心
感不到的 同理心
都是我不曾拥有过的事物
是什么Story？
谁人的Story？
正因没能收入手 才更想拥有
你说是吧

给我信号吧
举起麦克风吧
那家伙如今
正搭乘上顺风之势前进
大好机会在眼前
DIVE这就开始 HATER!

我们重新开始  意在此  才第一次
\"看上去\"
虽只有如此而已  也并不差吧
理由什么的 不必知道
理由什么的 并不需要
命运 规则又与我何干

我们重新开始  意在此  路不止
\"想见识\"
虽只是如此而已  也不算坏吧
让我奏响吧 Groovy
让我听听吧 Heart Beat
止步不前的闲暇之类  并不存在


啊—啊— Mic Check 一 二
ALL NIGHT走起 意外可以~
说着这话的你  不就是小丑（笑）
上游名流？ 那听我异议！

RAD又BAD的UNDER DOG现
鸡皮疙瘩 如感电 VIVID 一色染遍
唯  高处 方能 入眼
今天的（TODAY）你就是
秘藏着斗志的 烦恼中的胜家犬

给我信号吧
举起麦克风吧
我们如今
正搭乘上  顺风之势前进
大好机会在眼前
DIVE这就开始 HATER!

我们重新开始  意在此  才第一次
\"看上去\"
虽只有如此而已  也并不差吧
理由什么的不必知道
理由什么的并不需要
背德的快感  弥留舌尖

我们重新开始  意在此  路不止
\"想见识\"
虽只是如此而已  也不算坏吧
让我奏响吧 Groovy
让我听听吧 Heart Beat
止步不前的闲暇之类  并不存在

感受顺风推我往前
Alright 再不会回头
向前进
"
                    }
                }
            }
            MenuItem {
                text: "关于"
                onClicked: {
                    messageDialog_about.open()
                }
                MessageDialog {
                    id: messageDialog_about
                    modality: Qt.ApplicationModal
                    title: "关于"
                    detailedText: $operateMgr.getDetail()
                    text: "本程序用于处理歌词与翻译的时间轴"
                    informativeText: "作者:舰长的初号\nid:257800231"
                    onButtonClicked: {
                        if(button === MessageDialog.Ok) {
                            close()
                        }
                    }
                }
            }
        }
    }
    Item {
        id: root
        anchors.fill: parent
        property bool isPreview: false
        property alias textArea_lrc: textArea_lrc
        property alias textArea_trans: textArea_trans
        //用于保存翻译的备份
        property string textBackup: ""

        property bool lock: true//用于两个滚动条的互斥锁

        Column {
            anchors.fill: parent
            spacing: 4
            Row {
                id: row0
                width: parent.width
                Text {
                    width: parent.width / 2
                    id:text1
                    text: "歌词"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                Text {
                    width: parent.width / 2
                    id:text2
                    text: "翻译"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }

            Row {
                id: row1
                width: parent.width
                height: parent.height - row0.height - row2.height
                Item {
                    width: parent.width/2
                    height: parent.height
                    ScrollView {
                        id: scrollView1
                        anchors.fill: parent
                        ScrollBar.vertical: ScrollBar {
                            id: scrollBar1
                            parent: scrollView1.parent
                            anchors.top: scrollView1.top
                            anchors.right: scrollView1.right
                            anchors.bottom: scrollView1.bottom
                            onPositionChanged: {
                                if(root.lock) {
                                    root.lock = false
                                    scrollBar2.position = ((textArea_lrc.lineCount*1.0)/(textArea_trans.lineCount*1.0))*scrollBar1.position
                                    root.lock = true
                                }
                            }
                        }

                        TextAreaNormal {
                            //备份保存目录
                            property string lrcBackupPath: ".lrc.txt"
                            id: textArea_lrc
                            text: $operateMgr.readFile(lrcBackupPath)
                            onEditingFinished: {
                                root.saveBackup()
                            }
                        }
                    }
                }
                Rectangle {
                    opacity: 0.2
                    width: 2
                    height: parent.height
                    color: "grey"
                }
                Item {
                    width: parent.width/2
                    height: parent.height
                    ScrollView {
                        id: scrollView2
                        anchors.fill: parent
                        ScrollBar.vertical: ScrollBar {
                            id: scrollBar2
                            parent: scrollView2.parent
                            anchors.top: scrollView2.top
                            anchors.right: scrollView2.right
                            anchors.bottom: scrollView2.bottom

                            onPositionChanged: {
                                if(root.lock) {
                                    root.lock = false
                                    scrollBar1.position=((textArea_trans.lineCount*1.0)/(textArea_lrc.lineCount*1.0))*scrollBar2.position
                                    root.lock = true
                                }
                            }
                        }

                        TextAreaNormal {
                            //备份保存目录
                            property string transBackupPath: ".trans.txt"
                            id: textArea_trans
                            text: $operateMgr.readFile(transBackupPath)
                            onEditingFinished: {
                                root.saveBackup()
                            }
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

            Item {
                id: row2
                height: button_preview.height + 5
                width: parent.width
                Button {
                    id: button_preview
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 5
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
                    anchors.verticalCenter: button_preview.verticalCenter
                    checked: false
                    text: "合并为一句"
                }
            }

        }

        function saveBackup() {
            $operateMgr.saveFile(root.textArea_trans.transBackupPath,
                                 root.textArea_trans.text)
            $operateMgr.saveFile(root.textArea_lrc.lrcBackupPath,
                                 root.textArea_lrc.text)
        }

        function process() {
            if(isPreview) {
                root.textBackup = textArea_trans.text
                let lrcList = textArea_lrc.text.split("\n")
                let transList = textArea_trans.text.split("\n")
                let result= ""
                for(let i=0;i<Math.max(lrcList.length,transList.length);++i) {
                    if(i<lrcList.length) {
                        if(lrcList[i].indexOf("[") !== -1 && lrcList[i].indexOf("]") !== -1) {
                            if(checkBox.checkState !== Qt.Checked) {
                                result = result + lrcList[i].substring(lrcList[i].indexOf("["),lrcList[i].indexOf("]") + 1)
                            }
                            else result += (lrcList[i]+" ")
                        }
                    }
                    if(i<transList.length) {
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
//    Drawer {
//        id: drawer2
//        edge: Qt.RightEdge  //从右边滑入
//        width: 0.3 * root.width
//        height: root.height
//        dragMargin: parent.width / 3

//        Column {
//            anchors.centerIn: parent
//            spacing: 30

//            Rectangle {
//                width: 100
//                height: 100
//                color: "blue"
//            }
//            Rectangle {
//                width: 100
//                height: 100
//                color: "orange"
//            }
//            Rectangle {
//                width: 100
//                height: 100
//                color: "green"
//            }
//        }
//    }
    onClosing: {
        root.saveBackup()
    }
}
