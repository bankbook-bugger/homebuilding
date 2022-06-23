import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

AppButton {
  id: textButton
  width: screenText.width + 20
  height: 30

  // background color
  property color color: "#413d3c"
  property var radius:3
  property alias screenText: screenText.text
  property alias textColor: screenText.color

  // we override the default Felgo style with our own
  style: ButtonStyle {
    background: Rectangle {
      radius: 3
      color: "#413d3c"
    }
  }

  //onClicked: audioManager.playSound("click")

  // text displayed in the button
  Text {
    id: screenText
    color:"white"
    anchors.centerIn: parent
    font.pixelSize: 12
  }

  // this white rectangle covers the button when the mouse hovers above it
  Rectangle {
    anchors.fill: parent
    radius: textButton.radius
    color: "white"
    opacity: hovered ? 0.3 : 0
  }
}
