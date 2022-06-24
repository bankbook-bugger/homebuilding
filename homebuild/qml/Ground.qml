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
        collidesWith: Box.Category1|Box.Category2
    }
}
