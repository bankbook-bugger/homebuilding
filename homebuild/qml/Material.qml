import QtQuick 2.0
import Felgo 3.0
//所有可收集的素材的基类
HomeEntityBaseDraggable{
    id:material
    entityType: "material"
    //判断是否被收集
    property bool collected:false
    //如果被收集了就不显示
    image.visible: !collected
    //没有碰撞发生事才允许构建
    colliderComponent: collider
    CircleCollider{
        id:collider
        //碰撞检测的部分比实际区域小
        radius:parent.width/2-1
        //因为碰撞检测的部分比实际区域小，但是依旧是碰撞的左上角和实际的左上角对齐，所以圆点中心会有偏移
        x:1
        y:1
        //被收集后就不生效了
        active: !collected
        bodyType: Body.Static
        //碰撞器仅用于碰撞检测而不用于位置更新
        collisionTestingOnlyMode: true
        //Category6:可收集的素材
        categories:Box.Category3
        //Category1:玩家
        collidesWith: Box.Category1
    }
    function collect()
    {
        material.collected=true
    }
    function reset(){
        material.collected=false
    }

}
