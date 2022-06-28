import QtQuick 2.0
import Felgo 3.0
import "../qml/scenes/editorElements"

HomeEntityBaseDraggable{
    id:monster
    entityType: "monster"
    property int startX
    property int startY
    z:1
    //是不是活着
    property bool alive:true
    //隐藏掉怪物的尸体
    property bool hidden:false
    width:image.width
    height:image.height
    //如果死了就隐藏
    image.visible: !hidden
    //更新实体的位置
    onEntityCreated: updateStartPosition()
    onEntityReleased: updateStartPosition()
    //尸体呆了两秒后消失
    Timer{
        //
        id:hideTimer
        interval: 2000
        onTriggered: hidden=true
    }
    function updataStartPosition(){
        startX=x
        startY=y
    }
    function reset_super(){
        alive=true
        hideTimer.stop()
        hidden=false
        //当前物理体在x,y上的速度
        collider.linearVelocity.x=0
        collider.linearVelocity.y=0
        //施加力的点
        collider.force = Qt.point(0, 0)
    }
    function die(){
        alive=flase
        hideTimer.start()
        musicManager.playSound("opponentWalkerDie")
    }
}
