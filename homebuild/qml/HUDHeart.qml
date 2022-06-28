/*2022.6.27
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

Rectangle {
    property alias heart: heart

    //只有玩游戏时可见
    visible: gameScene.state != "edit"

    width: heart.width + 10
    height: 20

    anchors.top: gameScene.gameWindowAnchorItem.top
    anchors.left: gameScene.gameWindowAnchorItem.left   //整体在玩游戏时左上角
    anchors.margins: 4
    radius: 3
    color: "transparent"


    MultiResolutionImage {        //加入生命的图片
      id: heart
      height: parent.height
      width: height

      anchors.left: parent.left
      anchors.leftMargin: 2
    }

  }
