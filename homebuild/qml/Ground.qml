import QtQuick 2.0
import Felgo 3.0

<<<<<<< HEAD
HomeEntityBaseDraggable{
    id:ground
    entityType: "ground"
    colliderComponent: collider
    BoxCollider{
        id:collider
        anchors.fill: parent
        bodyType: Body.Static
        //Category4:地
        categories: Box.Category4
        //Category1:玩家  Category2:怪物
        //Category6:玩家的sensor  Category7:怪物的sensor
        collidesWith: Box.Category1|Box.Category2|Box.Category6|Box.Category7
    }
=======
// this is the base class for all Ground objects
HomeEntityBaseDraggable {
  id: ground
  entityType: "ground"

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  BoxCollider {
    id: collider

    anchors.fill: parent
    bodyType: Body.Static

    // Category5: solids
    categories: Box.Category5
    // Category1: player body, Category2: player feet sensor,
    // Category3: opponent body, Category4: opponent sensor
    collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4
  }
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
}
