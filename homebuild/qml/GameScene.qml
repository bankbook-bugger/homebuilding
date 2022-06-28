import Felgo 3.0
import QtQuick 2.15
import QtQuick.Controls.Styles 1.0
/*
  2020051615113wangmin,chenzhexi,wanglingzhi
  function:gameScene
  */
SceneBase {
    id:gameScene
    z:3
    gridSize: 32
    sceneAlignmentX: "left"
    sceneAlignmentY: "top"
    property int time: 0
    property string activeLevelFileName
    property variant activeLevel
    property alias editorOverlay: editorOverlay
    property alias container: container
    property alias player: player
    property alias physicsWorld: physicsWorld
    property alias bgImage: bgImage
    property alias camera: camera
    property alias itemEditor: editorOverlay.itemEditor
    signal backPressed


    //得到选择关卡名字
    function setLevel(fileName) {
        activeLevelFileName = fileName
    }


    state: "edit"         //编辑
    states: [
        State {
            name: "play"
            StateChangeScript {script: musicManager.handleMusic()}
        },
        State {
            name: "edit"
            //设置为没有重力
            PropertyChanges {target: physicsWorld; gravity: Qt.point(0,0)}
            PropertyChanges {target: editorUnderlay; enabled: true}
            PropertyChanges {target: editorOverlay; visible: true}
            PropertyChanges {target: editorOverlay; inEditMode: true}
            StateChangeScript {script: resetLevel()}
            StateChangeScript {script: editorOverlay.grid.requestPaint()}
            StateChangeScript {script: musicManager.handleMusic()}
        },
        State {
            name: "test"
            PropertyChanges {target: editorOverlay; visible: true} // show the editorOverlay
            StateChangeScript {script: musicManager.playSound("start")}
            StateChangeScript {script: musicManager.handleMusic()}
            PropertyChanges {target: gameScene; time: 0}
            StateChangeScript {script: levelTimer.restart()}
            PropertyChanges {target: camera; zoom: 1}
        },
        State {
            name: "finish"
            PropertyChanges {target: physicsWorld; running: false} // disable physics
        }
    ]


    //  游戏场景的背景
    BackgroundImage {
        id: bgImage
        anchors.fill: parent.gameWindowAnchorItem
        anchors.centerIn: parent.gameWindowAnchorItem
        source: "../assets/backgroundImage/bg.jpg"
    }
    Text {
        anchors.left: gameScene.gameWindowAnchorItem.left
        anchors.leftMargin: 10
        anchors.top: gameScene.gameWindowAnchorItem.top
        anchors.topMargin: 10
        color: "white"
        font.pixelSize: 20
        text: activeLevel !== undefined ? activeLevel.levelName : ""
    }


    //游戏元素
    Item {
        id: container
        transformOrigin: Item.TopLeft
        PhysicsWorld {
            id: physicsWorld
            property int gravityY: 40
            gravity: Qt.point(0, gravityY)
            debugDrawVisible: false
            z: 1000
            running: true
            onPreSolve: {
                var entityA = contact.fixtureA.getBody().target
                var entityB = contact.fixtureB.getBody().target
<<<<<<< HEAD
                //禁用玩家之间的物理碰撞处理
                //和对手。这样，我们仍然可以处理它们，
                //但它们的物理特性没有受到影响。
=======

>>>>>>> 3be81b09c27ffe90c132d7c3db828e938d7b20f9
                if(entityA.entityType === "player" && entityB.entityType === "monster"
                        || entityB.entityType === "player" && entityA.entityType === "monster") {
                    contact.enabled = false
                }
            }


            EditableComponent {
                editableType: "Balance"
                defaultGroup: "Physics"
                properties: {
                    "gravityY": {"min": 0, "max": 100, "label": "Gravity"}
                }
            }
        }


        Player {
            id: player
            z: 1
            onFinish: {
                if(gameScene.state == "test")
                    //如果是test状态下赢了，就直接重来，不显示对话框
                    resetLevel()
                else if(gameScene.state == "play") {
                    //显示对话框
                    gameScene.state = "finish"

                    finishDialog.score =score
                    finishDialog.opacity = 1
                }
            }
        }

        ResetSensor {
            player: player
            onContact: {
                player.die(true)
            }
        }

    }
    MoveTouchButton {
        id: moveTouchButton
        controller: controller
    }


    JumpTouchButton {
        id: jumpTouchButton
//        onPressed: player.startJump(true)
//        onReleased: player.endJump()
    }


    //将键盘键转发到控制器
    Keys.forwardTo: controller
    //以下是人对屏幕的操作
    EditorUnderlay {
        id: editorUnderlay
    }
    Camera {
        id: camera
        // 设置场景的大小
        gameWindowSize: Qt.point(gameScene.gameWindowAnchorItem.width, gameScene.gameWindowAnchorItem.height)
        entityContainer: container
        // 禁用相机的鼠标earea，在编辑时中自动移动相机(手的移动)
        mouseAreaEnabled: false
        focusedObject: gameScene.state != "edit" ? player : null
        focusOffset: Qt.point(0.5, 0.3)
        limitLeft: 0
        limitBottom: 0
        freeOffset: gameScene.state != "edit" ? Qt.point(0, 0) : Qt.point(100, 0)
    }
    EditorOverlay {
        id: editorOverlay
        visible: false
        scene: gameScene
    }
    //轴控制器
    TwoAxisController {
        id: controller
        // 只有在玩游戏的时候才启用控制器
        enabled: gameScene.state != "edit"
        // 键盘输入
        onInputActionPressed: {
            console.debug("key pressed actionName " + actionName)
            if(actionName == "up") {
                player.startJump(true)
            }
        }
        onInputActionReleased: {
            if(actionName == "up") {
                player.endJump()
            }
        }
        // 如果x轴改变，就随着人物改变的方向改变人物的视线方向
        onXAxisChanged: player.changeSpriteOrientation()
    }
    FinishDialog {
        id: finishDialog
    }
    //显示得分
    HUDIconAndText {
        id: timeDisplay
        text: time
        icon.source: "../assets/ui/time.png"
    }
    HomeImageButton {
        id: menuButton
        width: 40
        height: 30
        style: ButtonStyle{
            background: Rectangle{
                radius: 3
                color:"transparent"
            }
        }
        anchors.right: editorOverlay.right
        anchors.top: editorOverlay.top
        image.source: "../assets/ui/home.png"
        visible: gameScene.state == "play"
        onClicked: backPressed()
    }




    //js实现的功能
    // 初始化关卡加载级别后调用此函数
    function initLevel() {
        editorOverlay.initEditor()
        if(bgImage.loadedBackground && bgImage.loadedBackground !== -1)
            bgImage.bg = bgImage.loadedBackground
        else
            bgImage.bg = 0
        camera.zoom = 1
        camera.freePosition = Qt.point(0, 0)
        player.initialize()
        player.resetContacts()
        controller.xAxis = 0
    }
    function resetLevel() {
        editorOverlay.resetEditor()
        player.reset()
        var opponents = entityManager.getEntityArrayByType("monster")
        for(var opp in opponents) {
            opponents[opp].reset()
        }
        var materials = entityManager.getEntityArrayByType("material")
        for(var material in materials) {
            materials[material].reset()
        }
    }
}
