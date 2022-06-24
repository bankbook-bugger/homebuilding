import QtQuick 2.0
import Felgo 3.0

DialogBase {
  id: removeLevelDialog

  Text {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 100
    text: "What do you want to do?"
    color: "white"
  }

  HomeTextButton {
    id: saveAndExitButton

    screenText: "Save and Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 150

    onClicked: {
      editorOverlay.saveLevel()
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  HomeTextButton {
    id: discardAndExitButton

    screenText: "Exit"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 100

    onClicked: {
      editorOverlay.scene.backPressed()

      removeLevelDialog.opacity = 0
    }
  }

  HomeTextButton {
    id: cancelButton

    screenText: "Cancel"

    width: 175

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50

    onClicked: removeLevelDialog.opacity = 0
  }
}

