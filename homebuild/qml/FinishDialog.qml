import QtQuick 2.0
import Felgo 3.0

DialogBase {
  id: finishDialog
<<<<<<< HEAD

=======
>>>>>>> 50d4287f518f34511069d8b196beb7ad8e167d7b
  //点击背景关闭对话框
  closeableByClickOnBackground: false

  // this holds the score, the player achieved
  property real score

  Text {
    anchors.centerIn: parent
    anchors.verticalCenterOffset: -20
<<<<<<< HEAD

=======
>>>>>>> 50d4287f518f34511069d8b196beb7ad8e167d7b
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
<<<<<<< HEAD


    screenText: "重玩"

=======
    screenText: "重玩"
>>>>>>> 50d4287f518f34511069d8b196beb7ad8e167d7b
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
<<<<<<< HEAD

      finishDialog.opacity = 0

      gameScene.state = "play"
=======
      finishDialog.opacity = 0

      gameScene.state = "play"

>>>>>>> 50d4287f518f34511069d8b196beb7ad8e167d7b
      gameScene.backPressed()
    }
  }
}

