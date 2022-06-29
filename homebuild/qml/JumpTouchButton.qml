/*2022.6.27
  wanglingzhi*/

import Felgo 3.0
import QtQuick 2.15


import QtQuick.Controls 2.15

Item {
  id: jumpTouchButton

  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible
  //只有在触摸模式 hand 手模式下才能启用

  signal pressed
  signal released

  height: 60
  width: 80

  anchors.right: gameScene.gameWindowAnchorItem.right
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  Rectangle {                    //按钮图像的背景 只在按下时候有用
    id: background
    anchors.fill: parent
    radius: height
    color: "#ffffff"
    opacity: 0.5
    visible: false       //默认不可见 只有按下按钮时 可见
  }

  MultiResolutionImage {
    id: image
    source: "../assets/ui/arrow_up.png"
    anchors.fill: background

    fillMode: Image.PreserveAspectFit
    scale: 0.5           //占了按钮一半的位置
  }


  TapHandler{

    onTapped: {
      jumpTouchButton.pressed()  //按下按钮为 jump时 才显示
      background.visible = true
    }
    onCanceled: {
      jumpTouchButton.released() //松开按钮时 为不可见
      background.visible = false
    }
  }
}
