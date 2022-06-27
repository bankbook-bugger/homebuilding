import QtQuick 2.0
import Felgo 3.0

Ground{
    variationType: "left"
    image.source: "../assets/ground/ground3.png"
    colliderComponent: leftcollider
    PolygonCollider {
      id: leftcollider
      anchors.fill: parent
      vertices:
      [
        Qt.point(0, 0),
        Qt.point(0, 30),
        Qt.point(30, 30),
      ]
      bodyType: Body.Static
      // Category4: 地
      categories: Box.Category4
      //Category1:玩家  Category2:怪物
      //Category6:玩家的sensor  Category7:怪物的sensor
      collidesWith: Box.Category1|Box.Category2|Box.Category6|Box.Category7

   }
}
