/*2022.6.27
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

Rectangle {
    property alias text: textItem.text
    property alias icon: icon

    //只有玩游戏时可见
    visible: gameScene.state != "edit"

    width: textItem.width + icon.width + 10
    height: 20

    anchors.top: gameScene.gameWindowAnchorItem.top
    anchors.left: gameScene.gameWindowAnchorItem.right   //整体在玩游戏时右上角
    anchors.margins: 4

    radius: 3
    color: "#80ffffff"


    MultiResolutionImage {        //加入金币的图片
      id: icon
      height: parent.height
      width: height

      anchors.left: parent.left
      anchors.leftMargin: 2
    }


    Text {                   //金币的数值显示
      id: textItem

      height: parent.height
      verticalAlignment: Text.AlignVCenter
      anchors.left: icon.right
      anchors.leftMargin: 2
    }

  }
