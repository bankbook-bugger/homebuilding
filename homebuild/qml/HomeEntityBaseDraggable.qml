import QtQuick 2.15
import Felgo 3.0

EntityBaseDraggable{
    id:entityBase
    //当前实体在哪个场景中
    property var scene:gameScene
    //实体的图片
    property alias image:sprite
    //实体拖动到的最后的位置
    property point lastPosition
    Component.onCompleted: lastPosition=Qt.point(x,y)
    width:sprite.width
    height:sprite.height
    //gridSize是什么？？
    gridSize: scene.gridSize
    MultiResolutionImage{
        id:sprite
    }

}
