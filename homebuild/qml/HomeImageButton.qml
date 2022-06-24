/*2022.6.23
wanglingzhi chenzexi*/

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

  style: ButtonStyle {         //覆盖默认felgo的样式
    background: Rectangle {
      radius: imageButton.radius
      color: "#413d3c"
    }
  }
  onClicked: musicManager.playSound("click")   //点击样式 播放音乐

  MultiResolutionImage {
    id: image
    anchors.fill: parent
    anchors.margins: 1
    fillMode: Image.PreserveAspectFit
  }


  Rectangle {                           //当鼠标悬停在上方时 此白色矩形覆盖
    id: hoverRectangle
    anchors.fill: parent
    radius: imageButton.radius
    color: "white"
    opacity: hovered ? 0.3 : 0
  }


}
