import QtQuick 2.0
import Felgo 3.0

HomeEntityBaseDraggable {
  id: spikes
  entityType: "spikes"
  variationType: "up"

  width: image.width
  height: image.height

  colliderComponent: collider

  image.source: "../assets/spikes/spikes.png"

  BoxCollider {
    id: collider

    width: parent.width
    height: parent.height / 2 + 1

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom

    bodyType: Body.Static

    //当前状态为编辑页面时不生效
    active: !inLevelEditingMode
    //Category4:地
    categories: Box.Category4
    //Category1:玩家  Category2:怪物
    //Category6:玩家的sensor  Category7:怪物的sensor
    collidesWith: Box.Category1|Box.Category2|Box.Category6|Box.Category7
  }
}

