/* 2022.6 28
  wanglingzhi chenzexi*/

import QtQuick 2.0
import Felgo 3.0

//所有可收集的素材的基类
HomeEntityBaseDraggable{
    id:heart
    entityType: "heart"

    property bool collected:false//判断是否被收集

    image.visible: !collected  //如果被收集了就不显示

    colliderComponent: collider //没有碰撞发生事才允许构建


    image.source: "../assets/ui/red_heart.png" //收集生命的图片

    CircleCollider{
        id:collider
        //碰撞检测的部分比实际区域小
        radius:parent.width/2-1
        //因为碰撞检测的部分比实际区域小，但是依旧是碰撞的左上角和实际的左上角对齐，所以圆点中心会有偏移
        x:1
        y:1

        active: !collected //被收集后就不生效了
        bodyType: Body.Static

        collisionTestingOnlyMode: true //碰撞器仅用于碰撞检测而不用于位置更新

        categories:Box.Category3 //Category6:可收集的素材

        collidesWith: Box.Category1 //Category1:玩家
    }
    function collect()
    {
        heart.collected=true
    }
    function reset(){
        heart.collected=false
    }

}
