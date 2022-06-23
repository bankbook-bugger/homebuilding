import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

AppButton {
  id: imageButton
  height: parent.height
  property int radius: 3
  property color color: "#413d3c"
  property alias image: image
  property alias hoverRectangle: hoverRectangle

  // we override the default Felgo style with our own style
  style: ButtonStyle {
    background: Rectangle {
      radius: imageButton.radius
      color: "#413d3c"
    }
  }
//  onClicked: audioManager.playSound("click")

  // the image displayed
  MultiResolutionImage {
    id: image

    anchors.fill: parent
    anchors.margins: 1

    fillMode: Image.PreserveAspectFit
  }

  // this white rectangle covers the button when the mouse hovers above it
  Rectangle {
    id: hoverRectangle
    anchors.fill: parent
    radius: imageButton.radius
    color: "white"
    opacity: hovered ? 0.3 : 0
  }
}
