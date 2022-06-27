import QtQuick 2.0
import Felgo 3.0

Rectangle {
    property alias text: textItem.text
    property alias icon: icon

    visible: gameScene.state != "edit"


    width: textItem.width + icon.width + 10
    height: 20


    anchors.top: gameScene.gameWindowAnchorItem.top
    anchors.left: gameScene.gameWindowAnchorItem.left
    anchors.margins: 4


    radius: 3


    color: "#80ffffff"


    MultiResolutionImage {
      id: icon


      height: parent.height
      width: height


      anchors.left: parent.left
      anchors.leftMargin: 2
    }


    Text {
      id: textItem

      height: parent.height


      verticalAlignment: Text.AlignVCenter


      anchors.left: icon.right
      anchors.leftMargin: 2
    }
  }
