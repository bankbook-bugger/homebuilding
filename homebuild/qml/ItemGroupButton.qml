/*2022.6.24
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

//这个qml用于写自定义游戏界面 侧边栏的一组 一组的按钮作为一组

HomeImageButton {
  id: itemGroupButton

  width: parent.buttonWidth
  height: parent.height

 //使得颜色转换为白色 否则为灰色
  color: selected ? "#c0c0c0" : "#ffffff"

  property bool selected: false
}
