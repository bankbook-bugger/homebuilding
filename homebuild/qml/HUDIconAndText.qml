/*2022.6.27
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

Rectangle {
    property alias text: textItem.text
    property alias icon: icon

    //只有玩游戏时可见
    visible: gameScene.state != "edit"

    width: textItem.width + icon.width + 10  //整个的宽度为图片加上数值
    height: 20

    anchors.left: gameScene.gameWindowAnchorItem.left   //整体在玩游戏时左上角
    anchors.margins: 4
    radius: 3
    color: "transparent"


    MultiResolutionImage {        //加入金币的图片
      id: icon
      height: parent.height
      width: height

      anchors.left: parent.left
      anchors.leftMargin: 2
    }


    Text {                    //金币的数值显示
      id: textItem
      height: parent.height
      verticalAlignment: Text.AlignVCenter
      anchors.left: icon.right
      anchors.leftMargin: 4
    }


  }
