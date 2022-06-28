import QtQuick 2.0
import Felgo 3.0

Ground
{
    entityType: "mud"
    image.source: "../assets/ground/mud.png"
    colliderComponent: mudcollider
    BoxCollider{
        id:mudcollider
        anchors.fill: parent
        friction: 0.9
        bodyType: Body.Static
        //Category4:地
        categories: Box.Category4
        //Category1:玩家  Category2:怪物
        collidesWith: Box.Category1|Box.Category2
    }
}
