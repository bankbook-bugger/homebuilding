/*2022.6.27
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

//qml 用于删除当前编辑的地图(关卡)  确定是否保存的对话框

DialogBase {
  id: removeLevelDialog

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 100
    text: "你真的想要保存这个关卡吗？?"
    color: "white"
  }

  HomeTextButton {
    id: saveAndExitButton

    screenText: "保存和关闭当前对话框"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    onClicked: {
      editorOverlay.saveLevel()          //保存当前关卡
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0    //关闭当前对话框
    }
  }

  HomeTextButton {
    id: discardAndExitButton

    screenText: "关闭"
    width: 175
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    onClicked: {
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0  //关闭当前对话框
    }
  }

  HomeTextButton {
    id: cancelButton

    screenText: "取消当前操作"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    onClicked: removeLevelDialog.opacity = 0  //关闭当前对话框
  }
}

