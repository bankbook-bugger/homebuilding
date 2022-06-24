/*2022.6.23
wanglingzhi chenzexi*/

import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

AppButton {
  id: textButton
  width: screenText.width + 20
  height: 30

  property color color: "#413d3c"   //背景颜色
  property var radius:3
  property alias screenText: screenText.text
  property alias textColor: screenText.color

  style: ButtonStyle {                    //自定义样式覆盖
    background: Rectangle {
      radius: 3
      color: "#413d3c"
    }
  }

  onClicked: musicManager.playSound("click")

  Text {                                //文本展示按钮
    id: screenText
    color:"white"
    anchors.centerIn: parent
    font.pixelSize: 12
  }

  Rectangle {                             //当鼠标悬停在上方时 此白色矩形覆盖
    anchors.fill: parent
    radius: textButton.radius
    color: "white"
    opacity: hovered ? 0.3 : 0
  }
}
