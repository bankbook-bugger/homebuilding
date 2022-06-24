import QtQuick 2.15
import Felgo 3.0

Item {
  id: dialogBase

  z: 1000

  anchors.fill: parent.gameWindowAnchorItem ? parent.gameWindowAnchorItem : parent

  opacity: 0
  enabled: opacity > 0

  property bool closeableByClickOnBackground: true

  TapHandler {

    tapped: {
      if(closeableByClickOnBackground)
        dialogBase.opacity = 0
    }
  }

  Rectangle {
    anchors.fill: parent

    color: "black"
    opacity: 0.9
  }
}
