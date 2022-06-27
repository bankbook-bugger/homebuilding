import QtQuick 2.0
import Felgo 3.0

DialogBase {
  id: finishDialog
  //点击背景关闭对话框
  closeableByClickOnBackground: false

  property real score

  Text {
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -20
    text: "买房啦！!"
    font.pointSize: 33
    color: "white"
  }

  Text {
    anchors.centerIn: parent

    text: "Score: " + score

    color: "white"
  }

  // Buttons ------------------------------------------

  HomeTextButton {
    id: okButton
    screenText: "重玩"
    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 100

    onClicked: {
      finishDialog.opacity = 0

      gameScene.state = "play"

      gameScene.resetLevel()
    }
  }

  HomeTextButton {
    id: cancelButton

    screenText: "返回菜单"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.right: parent.right
    anchors.rightMargin: 100

    onClicked: {
      finishDialog.opacity = 0

      gameScene.state = "play"

      gameScene.backPressed()
    }
  }
}

