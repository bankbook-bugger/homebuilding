import Felgo 3.0
import QtQuick 2.0

Item {

  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible


  height: 60
  width: 160


  anchors.left: gameScene.gameWindowAnchorItem.left
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  property var controller


  Rectangle {
    id: backgroundLeft


    width: parent.width / 2
    height: parent.height

    anchors.left: parent.left

    radius: height


    color: "#ffffff"
    opacity: 0.5


    visible: false
  }

  MultiResolutionImage {
    id: imageLeft

    source: "../../assets/ui/arrow_left.png"


    anchors.fill: backgroundLeft

    fillMode: Image.PreserveAspectFit


    scale: 0.5
  }


  Rectangle {
    id: backgroundRight

    width: parent.width / 2
    height: parent.height

    anchors.right: parent.right

    radius: height

    // set color and opacity
    color: "#ffffff"
    opacity: 0.5

    visible: false
  }

  MultiResolutionImage {
    id: imageRight

    source: "../../assets/ui/arrow_right.png"

    // fill the right background
    anchors.fill: backgroundRight

    fillMode: Image.PreserveAspectFit

    // make it half the size of the background
    scale: 0.5
  }

  // handle touch events
  MultiPointTouchArea {
    anchors.fill: parent

    // set controller's xAxis depending on where the user presses
    // make backgrounds visible
    onPressed: {
      if(touchPoints[0].x < width/2) {
        controller.xAxis = -1
        backgroundLeft.visible = true
      }
      else {
        controller.xAxis = 1
        backgroundRight.visible = true
      }
    }

    onUpdated: {
      if(touchPoints[0].x < width/2)
        controller.xAxis = -1
      else
        controller.xAxis = 1
    }

    onReleased: {
      // reset xAxis to zero
      controller.xAxis = 0

      // make backgrounds invisible again
      backgroundLeft.visible = false
      backgroundRight.visible = false
    }
  }
}
