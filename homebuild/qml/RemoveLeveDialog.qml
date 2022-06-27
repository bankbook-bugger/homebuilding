/*2022.6.27
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

//qml 用于保存当前编辑的地图(关卡)  确定是否保存的对话框

DialogBase {
  id: removeLevelDialog

  property var levelData    //设置删除的数据

  Text {
    anchors.centerIn: parent
    text: "你真的想要删除这个关卡吗？"
    color: "white"
    font.pointSize: 24
  }

  HomeTextButton {                 //确认按钮
    id: okButton
    screenText: "删！"
    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 100

    onClicked: {

      levelScene.removeLevelPressed(levelData)      //删除关卡

      removeLevelDialog.opacity = 0             //关闭对话框
    }
  }

  HomeTextButton {
    id: cancelButton

    screenText: "不删吧～"

    width: 100
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.right: parent.right
    anchors.rightMargin: 100

    onClicked: removeLevelDialog.opacity = 0    //不删除的时候 只关闭对话框
  }
}

