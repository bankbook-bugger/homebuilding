import Felgo 3.0
import QtQuick 2.0

Item {
  id: jumpTouchButton


  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible

  // set size
  height: 60
  width: 80


  anchors.right: gameScene.gameWindowAnchorItem.right
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  signal pressed
  signal released

  Rectangle {
    id: background

    anchors.fill: parent

    radius: height


    color: "#ffffff"
    opacity: 0.5

    visible: false
  }

  MultiResolutionImage {
    id: image

    source: "../../assets/ui/arrow_up.png"


    anchors.fill: background

    fillMode: Image.PreserveAspectFit


    scale: 0.5
  }


  MouseArea {
    anchors.fill: parent

    onPressed: {
      jumpTouchButton.pressed()
      background.visible = true
    }


    onReleased: {
      jumpTouchButton.released()
      background.visible = false
    }
  }
}
