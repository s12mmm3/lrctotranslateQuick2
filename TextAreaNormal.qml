import QtQuick 2.12
import QtQuick.Controls 2.12

//添加右键菜单等功能
TextArea {
    id: root
    MouseArea {
        id: mouseArea
        anchors.fill: parent;
        acceptedButtons: Qt.RightButton //激活右键
        onClicked: {
            if (mouse.button === Qt.RightButton) { // 右键菜单
                contentMenu.popup()
            }
        }
    }
    Menu {
        id: contentMenu
        title: "编辑"
        width: 60
        MenuItem {
            width: parent.width
            enabled: root.canUndo
            text: "撤销"
//            shortcut: "Ctrl+X"
            onClicked: {
                root.undo()
            }
        }
        MenuItem {
            width: parent.width
            enabled: root.canRedo
            text: "恢复"
            onClicked: {
                root.redo()
            }
        }
        MenuSeparator { }
        MenuItem {
            text: "剪贴"
            onClicked: {
                root.cut()
            }
        }
        MenuItem {
            text: "复制"
            onClicked: {
                root.copy()
            }
        }
        MenuItem {
            text: "粘贴"
            enabled: root.canPaste
            onClicked: {
                root.paste()
            }
        }
        MenuSeparator { }
        MenuItem {
            text: "全选"
            onClicked: {
                root.selectAll()
            }
        }
        MenuItem {
            text: "清空"
            enabled: root.text !== ""
            onClicked: {
                root.clear()
            }
        }
    }
}
