import QtQuick 2.0
import Felgo 3.0

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
// this is the base class for all Ground objects

}
