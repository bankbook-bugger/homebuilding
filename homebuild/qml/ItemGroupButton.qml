/*2022.6.24
  wanglingzhi*/

import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

//这个qml用于写自定义游戏界面 侧边栏的一组 一组的按钮作为一组

HomeImageButton {
    id: itemGroupButton
    property bool selected: false
    width: parent.buttonWidth
    height: parent.height

    //选中为白色，否则为灰色
    style: ButtonStyle {                    //自定义样式覆盖
        background: Rectangle {
            radius: 3
            color: selected ? "#ffffff" : "#c0c0c0"
        }
    }
}
