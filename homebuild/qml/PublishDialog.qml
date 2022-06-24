import QtQuick 2.0
import Felgo 3.0

DialogBase {
  id: publishDialog

  Text {
    anchors.centerIn: parent

    text: "Do you really want to publish this level?"

    color: "white"
  }

  HomeTextButton {
    id: okButton

    screenText: "Ok"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.left: parent.left
    anchors.leftMargin: 100

    onClicked: {
      editorOverlay.saveLevel()
      levelEditor.publishLevel()

      publishDialog.opacity = 0
    }
  }

  HomeTextButton {
    id: cancelButton

    screenText: "Cancel"

    width: 100

    anchors.bottom: parent.bottom
    anchors.bottomMargin: 50
    anchors.right: parent.right
    anchors.rightMargin: 100

    onClicked: publishDialog.opacity = 0
  }
}

