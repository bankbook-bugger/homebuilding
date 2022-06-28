import QtQuick 2.0
import Felgo 3.0

Monster{
    id:monsterWalker
    variationType: "walker"
    //-1=左边 1=右边
    property int direction:-1
    property int speed:70

    // 判断生命的状态加载不同的图片，可以用不同的精灵？
    image.source: alive ? "../assets/opponent/opponent_walker.png"
                        : "../assets/opponent/opponent_walker_dead.png"
    //如果他是往右就用图片的镜像
    image.mirror: collider.linearVelocity.x<0?false:true
    colliderComponent: collider
    //如果死了就不做碰撞检测
    onAliveChanged: {
        if(!alive) {
            leftAbyssChecker.contacts = 0
            rightAbyssChecker.contacts = 0
        }
    }
    //不懂，又是实体池？？
    onMovedToPool: {
        leftAbyssChecker.contacts = 0
        rightAbyssChecker.contacts = 0
    }

    PolygonCollider {
        id: collider
        vertices: [
            Qt.point(1, 15),
            Qt.point(31, 15),
            Qt.point(31, 30),
            Qt.point(26, 31),
            Qt.point(6, 31),
            Qt.point(1, 30)
        ]
        bodyType: Body.Dynamic
        //在编辑的时候和死了以后碰撞检测不生效
        active: inLevelEditingMode || !alive ? false : true

        // Category2: 怪物
        categories: Box.Category2
        // Category1: 玩家
        // Category4: 地//Category6:玩家的sensor
        collidesWith: Box.Category1 | Box.Category4|Box.Category6
        // 竖直方向的速度为0,横着动
        linearVelocity: Qt.point(direction * speed, 0)
        onLinearVelocityChanged: {
            //走到头了换方向
            if(linearVelocity.x === 0)
                direction *= -1
            //
            linearVelocity.x = direction * speed
        }
    }
    // 防止怪物自己走到坑里
    BoxCollider {
        id: leftAbyssChecker
        // 只有主要的碰撞检测生效时才生效
        active: collider.active
        width: 5
        height: 5

        // 在怪物的左下角
        anchors.top: parent.bottom
        anchors.left: parent.left

        // Category7:怪物的sensor
        categories: Box.Category7
        // Category4: 地
        collidesWith: Box.Category4
        // 只做碰撞检测不更新位置
        collisionTestingOnlyMode: true

        //当contancts为0的时候这里就有个坑，怪物需要变换他的位置
        property int contacts: 0

        // 开始碰撞
        fixture.onBeginContact: contacts++
        //结束碰撞（脚下没有地了
        fixture.onEndContact: if(contacts > 0) contacts--
        onContactsChanged: {
            if(contacts == 0)
                direction *= -1

        }
    }

    BoxCollider {
        id: rightAbyssChecker

        active: collider.active

        width: 1
        height: 5
        anchors.top: parent.bottom
        anchors.right: parent.right

        // Category7:怪物的sensor
        categories: Box.Category7
        // Category4: 地
        collidesWith: Box.Category4
        collisionTestingOnlyMode: true

        property int contacts: 0

        fixture.onBeginContact: contacts++
        fixture.onEndContact:{
            if(contacts > 0) contacts--
        }

        onContactsChanged: {
            if(contacts == 0) direction *= -1
        }
    }

    // 编写关卡时怪物参数的调节框
    EditableComponent {
        editableType: "Balance"
        defaultGroup: "OpponentWalker"

        targetEditor: gameScene.itemEditor

        properties: {
            "speed": {"min": 0, "max": 300, "stepSize": 5, "label": "Speed"}
        }
    }
    onSpeedChanged: {
        collider.linearVelocity.x = direction * speed
    }

    // 玩家死了游戏场景重置要用
    function reset() {
        reset_super()
        direction = -1
        collider.linearVelocity.x = Qt.point(direction * speed, 0)
    }
    onDie:{
        alive=false
        hideTimer.start()
        musicManager.playSound("opponentWalkerDie")
    }
}
