/*2022.6.27
  wanglingzhi*/

import Felgo 3.0
import QtQuick 2.0

Item {
  visible: !system.desktopPlatform && gameScene.state != "edit"
  enabled: visible
  //只有在触摸模式 hand 手模式下才能启用

  height: 60
  width: 160

  anchors.left: gameScene.gameWindowAnchorItem.left
  anchors.bottom: gameScene.gameWindowAnchorItem.bottom

  property var controller  //控制玩家左右移动

  Rectangle {                 //左边按钮图像背景 仅按下时可见
    id: backgroundLeft
    width: parent.width / 2
    height: parent.height

    anchors.left: parent.left
    radius: height

    color: "#ffffff"
    opacity: 0.5
    visible: false
  }

  MultiResolutionImage {      //左边按钮的多分辨率类型图像
    id: imageLeft
    source: "../assets/ui/arrow_left.png"
    anchors.fill: backgroundLeft
    fillMode: Image.PreserveAspectFit

    scale: 0.5           //整体为高度的一半
  }


  Rectangle {                //右边按钮图像背景 仅按下时可见
    id: backgroundRight

    width: parent.width / 2
    height: parent.height

    anchors.right: parent.right
    radius: height

    color: "#ffffff"
    opacity: 0.5

    visible: false
  }

  MultiResolutionImage {     //右边按钮的多分辨率类型图像
    id: imageRight

    source: "../assets/ui/arrow_right.png"
    anchors.fill: backgroundRight
    fillMode: Image.PreserveAspectFit

    scale: 0.5    //整体为高度的一半
  }



  // 多点触摸事件
  MultiPointTouchArea {      //多点触摸类型(QML类型）
    anchors.fill: parent

    onPressed: {                 //根据按下的位置 设置控制器的X轴
                                 //press为类型信号
      if(touchPoints[0].x < width/2) {
        controller.xAxis = -1
        backgroundLeft.visible = true
      }
      else {
        controller.xAxis = 1
        backgroundRight.visible = true
      }
    }

    onUpdated: {              ////update为类型信号 更新x的值
      if(touchPoints[0].x < width/2)
        controller.xAxis = -1
      else
        controller.xAxis = 1
    }

    onReleased: {              //松开时候 重置x的值
      controller.xAxis = 0

      backgroundLeft.visible = false    //设置按钮背景 不可见
      backgroundRight.visible = false
    }
  }
}
