import QtQuick 2.15
import Felgo 3.0

HomeEntityBaseDraggable {
  id:finish
  property var i:image
  entityType: "finish"

  colliderComponent: collider
  image.source: "../assets/ui/room1.png"
  BoxCollider {
    id: collider
    anchors.fill: parent
    bodyType: Body.Static
    //Category4:地
    categories: Box.Category4
    //Category1:玩家  Category2:怪物
    //Category6:玩家的sensor  Category7:怪物的sensor
    collidesWith: Box.Category1|Box.Category2|Box.Category6|Box.Category7
    fixture.onBeginContact: {
        //获取和终点发生碰撞的另一方
      var otherEntity = other.getBody().target
      // 如果是玩家就胜利
      if(otherEntity.entityType === "player") {
        gameScene.player.finish()
      }
    }
  }

}
