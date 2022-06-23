import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

GameButton {
  id: imageButton

  height: parent.height

  // properties of the ButtonStyle background Rectangle
  property int borderWidth: 1
  property color borderColor: "black"
  property int radius: 3
  property color color: "white"

  // aliases to enable access to these components from the outside
  property alias image: image
  property alias hoverRectangle: hoverRectangle

  // we override the default Felgo style with our own style
  style: ButtonStyle {
    background: Rectangle {
      border.width: imageButton.borderWidth
      border.color: imageButton.borderColor
      radius: imageButton.radius
      color: "transparent"
    }
  }

  onClicked: audioManager.playSound("click")

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

    // when the mouse hovers over the button, this rectangle is slightly visible
    opacity: hovered ? 0.3 : 0
  }
}

