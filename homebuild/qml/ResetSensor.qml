/*2022.6.8
wanglingzhi*/

import Felgo 3.0
import QtQuick 2.0


//qml 作用于 重新设置传感器 此时为感应器 检测他是否掉出界外
EntityBase {      //实体基类
  id: resetSensor
  entityType: "resetSensor"

  property var player      //实例化人物

  x: player.x
  y: 0

  width: player.width
  height: 10

  visible: !player.inLevelEditingMode   //只有当为play状态才能够可见
  enabled: !player.inLevelEditingMode


  signal contact  // 当传感器与播放器碰撞时 会发出此信号

  BoxCollider{     // 正方形碰撞检测器 这个对撞机检查玩家是否到达关卡的底部
    anchors.fill: parent
    collisionTestingOnlyMode: true

    categories: Box.Category7 // 类别6：对手只能和1类型相碰撞
    collidesWith: Box.Category1 // 类别1：玩家身体与6相碰撞

    fixture.onBeginContact: {    //击中对手检测
      var otherEntity = other.getBody().target

      // 如果玩家被传感器击中 我们会发出一个信号 玩家die
      if(otherEntity.entityType === "player") {
        //直接修改实体玩家的位置
        resetSensor.contact()
      }
    }

  }

  //矩形和文本仅用于查看对手移动 将visible设置为true 便于查看
  Rectangle {
    visible: false

    y: -resetSensor.height   //对手y的值为玩家的高度
    width: parent.width
    height: parent.height

    anchors.horizontalCenter: parent.horizontalCenter
    color: "yellow"
    opacity: 0.5

    Text {                    //重置传感器 查看对手状态
      y: -resetSensor.height
      anchors.centerIn: parent
      text: "reset sensor"
      color: "white"
      font.pixelSize: 9
    }
  }
}

