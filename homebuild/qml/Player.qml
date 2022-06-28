import Felgo 3.0
import QtQuick 2.0

HomeEntityBaseDraggable {
    id: player
    entityType: "player"

    property int startX
    property int startY

    //两个方向上的速度
    property alias horizontalVelocity: collider.linearVelocity.x
    property alias verticalVelocity: collider.linearVelocity.y

    //收集到的金额
    property int score: 0
    //收集生命
    property int heart: 1

    // 不可以二连跳
    property bool doubleJumpEnabled: flase
    //如果玩家的脚下有地就不为0
    property int contacts: 0

    // these properties set the player's jump force for normal- and
    // kill-jumps
    property int normalJumpForce: 210
    property int killJumpForce: 420
    //此属性保存玩家的迭代次数
    //跳跃高度可以增加。我们用它来控制跳跃高度。
    //有关更多详细信息，请参阅ascentControl Timer
    property int jumpForceLeft: 20

    //玩家的加速力（加速度？？
    property int accelerationForce: 1000

    //当用户停止向左或向右按，根据什么减少玩家的速度
    property real decelerationFactor: 0.6

    //玩家的最大移动速度
    property int maxSpeed: 230

    //玩家啊的最大下降速度
    property int maxFallingSpeed: 800

    /**
   * Signals ----------------------------------------------------
   */

    // 游戏结束
    signal finish

    /**
   * Object properties ----------------------------------------------------
   */

    width: image.width
    height: image.height

    colliderComponent: collider

    image.source: "../assets/player/stand.png"

    //如果玩家接触到另一个实体，我们将设置他的状态“步行”。否则，我们将其设置为“跳跃”。
    //玩家只能在“步行”时跳跃
    state: contacts > 0 ? "walking" : "jumping"

    //如果设置了这个属性，EntityManager::removeAllEntities() 的调用不会删除这个实体
    preventFromRemovalFromEntityManager: true

    //下降的最大速度
    onVerticalVelocityChanged: {
        if(verticalVelocity > maxFallingSpeed)
            verticalVelocity = maxFallingSpeed
    }

    onFinish: musicManager.playSound("finish")

    /**
   * 碰撞检测部分---------------------------------------
   */

    //主要部分
    PolygonCollider {
        id: collider
        friction: 0.3
        vertices:
            [
            Qt.point(53, 10),
            Qt.point(37, 94),
            Qt.point(68, 94)
        ]
        bodyType: Body.Dynamic
        //在编辑就不生效
        active: !inLevelEditingMode
        // Category1: 玩家
        categories: Box.Category1
        // Category2: 怪物, Category4:地
        // Category3: 收集的素材, Category7: 怪物的sensor
        collidesWith: Box.Category2 | Box.Category3 | Box.Category4| Box.Category7
        //不会处于休眠状态
        sleepingAllowed: false

        force: Qt.point(controller.xAxis * accelerationForce, 0)

        // limit the horizontal velocity
        onLinearVelocityChanged: {
            if(linearVelocity.x > maxSpeed) linearVelocity.x = maxSpeed
            if(linearVelocity.x < -maxSpeed) linearVelocity.x = -maxSpeed
        }

        // this is called whenever the contact with another entity begins
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target
            //如果在泥巴上就把摩擦力设为1，其他组件上没有摩擦
            if(otherEntity.entityType === "mud") {
                collider.friction=1
            }
            else
                collider.friction=0
            //如果是素材就收集，然后金币加10
            if(otherEntity.entityType === "material") {
                otherEntity.collect()
                score += 10
            }
            if(otherEntity.entityType === "heart") {
                otherEntity.collect()
                if(heart<3)
                    heart+=1
            }
        }
        // 查看发生碰撞的是不是攻击物
        fixture.onContactChanged: {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "monster" || otherEntity.entityType === "spikes") {
                if(heart==0)
                {
                    musicManager.playSound("playerDie")
                    gameScene.resetLevel()
                }
                else {
                    heart-=1
                    musicManager.playSound("playerHit")
                }

            }
        }
    }

    //脚
    //因为玩家可以踩死怪物所以脚上有单独的碰撞检测
    Rectangle{
        color: "red"
        width: 32
        height: 10
        visible: gameScene.state === "edit" ? false : true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom
    }
    Rectangle{
        color: "green"
        width: 5
        height: 5
        anchors.horizontalCenter: parent.horizontalCenter
        y:player.y
    }
    Rectangle{
        color: "blue"
        width: 5
        height: 5
        anchors.horizontalCenter: parent.horizontalCenter
        y:player.y + player.height
    }
    BoxCollider {
        id: feetSensor
        width: 32
        height: 10

        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.bottom

        bodyType: Body.Dynamic

        active: gameScene.state === "edit" ? false : true

        // Category6: 玩家脚的感应
        categories: Box.Category6
        // Category2: 怪物, Category4: 地
        collidesWith: Box.Category2 | Box.Category4
        collisionTestingOnlyMode: true

        // this is called whenever the contact with another entity begins
        fixture.onBeginContact: {
            var otherEntity = other.getBody().target

            if(otherEntity.entityType === "monster") {
                // 判断玩家脚的位置
                var playerLowestY = player.y + player.height
                //怪物脚的位置
                var oppLowestY = otherEntity.y + otherEntity.height

                //如果玩家比怪物高出至少5px就算踩到
                if(playerLowestY < oppLowestY - 5) {
                    //怪物死
                    otherEntity.die()
                    //玩家可以踩在这里往更高出跳
                    startJump(false)
                }
            }
            //contacts等于0就掉下去
            else if(otherEntity.entityType === "mud" || otherEntity.entityType === "ground") {
                contacts++
            }
        }
        fixture.onEndContact: {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "mud" || otherEntity.entityType === "ground")
                contacts--
        }
    }

    //用户不能在玩家周围创建实体
    BoxCollider {
        id: editorCollider

        anchors.fill: parent

        collisionTestingOnlyMode: true

        // Category16: misc
        categories: Box.Category16
        //不设置with默认和所有的都能碰
    }

    /**
   * Update timer --------------------------------------------------------
   */

    //如果x方向没有命令就让他
    Timer {
        id: updateTimer

        //触发间隔是60ms
        interval: 60

        running: true
        repeat: true

        onTriggered: {

            var xAxis = controller.xAxis;

            // if xAxis is 0 (no movement command) we slow the player down
            // until he stops
            //如果x方向，没有命令，速度就减慢
            //那为什么不能直接停？？
            if(xAxis === 0) {
                //        if(Math.abs(player.horizontalVelocity) > 10)
                //          player.horizontalVelocity *= decelerationFactor
                //        else
                player.horizontalVelocity = 0
            }
        }
    }

    //跳的控制（看不懂
    Timer {
        id: ascentControl

        interval: 15
        repeat: true

        onTriggered: {
            // 如果jumpForceLeft > 0就让他跳
            if(jumpForceLeft > 0) {

                var verticalImpulse = 0
                //在跳跃开始时，我们将垂直度设置为0
                //施加较高的垂直脉冲，以获得较高的初始垂直
                //速度
                if(jumpForceLeft == 20) {
                    verticalVelocity = 0

                    verticalImpulse = -normalJumpForce
                }
                //在第一次强烈的冲动之后，我们只想慢慢的曾加垂直速度
                else if(jumpForceLeft >= 14) {
                    verticalImpulse = -normalJumpForce / 5
                }
                //然后，在大约三分之一的最大跳跃时间之后，我们进一步
                //减少垂直脉冲。
                else {
                    verticalImpulse = -normalJumpForce / 15
                }
                //随着时间的推移，减少垂直脉冲可以实现更精确的
                //控制跳跃高度。
                //此外，与使用常量相比，它给跳跃带来更自然的感觉
                //施加脉冲
                collider.applyLinearImpulse(Qt.point(0, verticalImpulse))
                // 减小jumpForceLeft
                jumpForceLeft--
            }
        }
    }

    //加在ItemEditor里的调节各种属性的

    EditableComponent {
        editableType: "Balance"
        properties: {
            "Player" : {
                "normalJumpForce": {"min": 0, "max": 400, "stepSize": 5, "label": "Jump Force"},
                "killJumpForce": {"min": 0, "max": 1000, "stepSize": 10, "label": "Kill Jump Force"},
                "accelerationForce": {"min": 0, "max": 5000, "stepSize": 10, "label": "Acceleration"},
                "maxSpeed": {"min": 0, "max": 400, "stepSize": 5, "label": "Speed"},
                "maxFallingSpeed": {"min": 5, "max": 1000, "stepSize": 5, "label": "Max Falling Speed"}
            }
        }
    }

    /**
   * Game related JS functions --------------------------------------------------
   */
    //当用户按下跳转按钮或玩家跳到对手身上。
    //当用户按下跳转按钮时，isNormalJump为true。
    //当在致命跳跃后跳跃时，isNormalJump为false。
    function startJump(isNormalJump) {
        if(isNormalJump) {
            //ascentControl跳的控制timer
            if(player.state == "walking") {
                ascentControl.start()
                musicManager.playSound("playerJump")
            }
        }
        else {
            //当杀死对手时，我们希望玩家跳跃一点点。我们只需设置verticalVelocity为负值。
            verticalVelocity = -killJumpForce
        }
    }

    //当用户释放跳转按钮时，调用此函数
    function endJump() {
        // stop ascentControl
        ascentControl.stop()

        // reset jumpForceLeft
        jumpForceLeft = 20
    }
    //根据玩家移动的方向更改玩家的图片的样式
    function changeSpriteOrientation() {
        if(controller.xAxis === -1) {
            image.mirrorX = true
        }
        else if (controller.xAxis === 1) {
            image.mirrorX = false
        }
    }

    /**
   * Start position JS functions -----------------------------------------------
   */
    //当实体被释放时调用此处理程序。
    //每次在编辑模式下释放玩家时，我们都会调用此函数
    onEntityReleased: updateStartPosition()
    function updateStartPosition() {
        startX = x
        startY = y
    }
    //此函数尝试从保存的地方加载起始位置，或加载为默认值
    function loadStartPosition() {
        //加载startx从保存的地方
        if(gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
                && gameWindow.levelEditor.currentLevelData["customData"]
                && gameWindow.levelEditor.currentLevelData["customData"]["playerX"]) {
            startX = parseInt(gameWindow.levelEditor.currentLevelData["customData"]["playerX"])
        }
        else {
            //如果没有保存的startx就默认加载
            startX = 32
        }
        if(gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
                && gameWindow.levelEditor.currentLevelData["customData"]
                && gameWindow.levelEditor.currentLevelData["customData"]["playerY"]) {
            startY = parseInt(gameWindow.levelEditor.currentLevelData["customData"]["playerY"])
        }
        else {
            //为什么有负值？？
            startY = -96
        }
    }

    /**
   * Init and reset JS functions -------------------------------------
   */

    function initialize() {
        loadStartPosition()
        reset()
        lastPosition = Qt.point(x, y)
    }

    function reset() {
        // reset position
        x = startX
        y = startY

        // reset velocity
        collider.linearVelocity.x = 0
        collider.linearVelocity.y = 0

        // reset score
        score = 0
    }

    function resetContacts() {
        //重置contact以确保玩家启动每个关卡时都是零触点。
        contacts = 0
    }
}
