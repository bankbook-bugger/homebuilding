import Felgo 3.0
import QtQuick 2.0
/*
  2020051615113wangmin
  function:gameScene
  */
SceneBase {
    id:gameScene
    z:3
    gridSize: 32
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

     sceneAlignmentX: "left"
     sceneAlignmentY: "top"
        //得到选择关卡名字
       function setLevel(fileName) {
         activeLevelFileName = fileName
       }
       Rectangle {
         id: background
         //gameWindowAnchorItem可用于将 Scene 的直接子项锚定到父 GameWindow ，而不是逻辑 Scene 大小
         anchors.fill: parent.gameWindowAnchorItem
         color: "pink"
       }
       Buttons{
         text: "Back"
         anchors.right: gameScene.gameWindowAnchorItem.right
         anchors.rightMargin: 10
         anchors.top: gameScene.gameWindowAnchorItem.top
         anchors.topMargin: 10
         onClicked: {
           gameWindow.state = "kinds"
         }
       }
      //  游戏场景的背景
       BackgroundImage {
         id: bgImage
        // z:40
//         anchors.fill: parent.gameWindowAnchorItem
         anchors.centerIn: parent.gameWindowAnchorItem
         property string bg0: "../../assets/backgroundImage/bg.png"
          property int loadedBackground:{source: bg0
      } }
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

         // When the container is scaled we want the transformation to
         // be applied from the top left corner, since this is also the
         // coordinates origin.
         transformOrigin: Item.TopLeft

         PhysicsWorld {
           id: physicsWorld

           property int gravityY: 40

           // set the gravity
           gravity: Qt.point(0, gravityY)

           debugDrawVisible: false // enable this for physics debugging
           z: 1000 // make sure the debugDraw is above all other game elements

           running: true

           //this is called before the Box2DWorld handles contact events
           onPreSolve: {
             var entityA = contact.fixtureA.getBody().target
             var entityB = contact.fixtureB.getBody().target

             // We want our platforms to be cloud platforms.
             // A cloud platform is a platform through which you can jump
             // from below.

             // If one of the colliding entities is a platform,
             // and the other a moving entity (player or opponent),
             // and the moving entity is below the platform...
             if(entityA.entityType === "platform" && (entityB.entityType === "player" || entityB.entityType === "opponent") && entityB.y + entityB.height > entityA.y + 1 // add +1 to avoid wrong border-line decisions
                 || (entityA.entityType === "player" || entityA.entityType === "opponent") && entityB.entityType === "platform" && entityA.y + entityA.height > entityB.y + 1) {

               // ...disable the contact
               contact.enabled = false
             }

             // Disable physical collision handling between player
             // and opponents. This way, we can still handle them,
             // but their physics are not affected.
             if(entityA.entityType === "player" && entityB.entityType === "opponent"
                 || entityB.entityType === "player" && entityA.entityType === "opponent") {
               contact.enabled = false
             }
           }

           // add gravity property to item editor
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

           z: 1 // let the player appear in front of the platforms

           // when colliding with the finish:
           // in test mode: reset the level
           // in play mode: go back to the menu
           onFinish: {
             if(gameScene.state == "test")
               resetLevel()
             else if(gameScene.state == "play") {
               // set state to finish, to freeze the game
               gameScene.state = "finish"

               // handle score
               handleScore()

               // show finish dialog
               finishDialog.score = time
               finishDialog.opacity = 1
             }
           }
         }
         ResetSensor {
           // This sensor is always at the bottom of the level, directly
           // below the player. So the player touches it just before he
           // would fall out of bounds at the bottom of the level.
           // When he touches it, he dies.

           player: player

           // if the player collides with the reset sensor, he dies
           onContact: {
             player.die(true)
           }
         }
       }

       MoveButton {
         id: moveTouchButton
         controller: controller
       }
       JumpButton {
         id: jumpTouchButton
         onPressed: player.startJump(true)
         onReleased: player.endJump()
       }
       //将键盘键转发到控制器
       Keys.forwardTo: controller
       //以下是人对屏幕的操作
       EditorUnderlay {
         id: editorUnderlay
       }
       Camera {
         id: camera

         gameWindowSize: Qt.point(gameScene.gameWindowAnchorItem.width, gameScene.gameWindowAnchorItem.height)
         entityContainer: container

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
       //抬头显示器
       HUDIconAndText {
         id: timeDisplay
         text: time
         icon.source: "../../assets/ui/time.png"
       }
       Timer {
         id: levelTimer

         interval: 100

         repeat: true

         onTriggered: {
           // increase time
           time += 1
         }
       }
       FinishDialog {
         id: finishDialog
       }
       HomeImageButton {
         id: menuButton

         width: 40
         height: 30

         anchors.right: editorOverlay.right
         anchors.top: editorOverlay.top

         image.source: "../../assets/ui/home.png"

         // this button should only be visible in play or edit mode
         visible: gameScene.state == "play"

         // go back to menu
         onClicked: backPressed()
       }
       //js实现的功能
       function handleScore() {
         // id仅存在于已发布的级别中
         var leaderboard = levelEditor.currentLevelData.levelMetaData ? levelEditor.currentLevelData.levelMetaData.id : undefined

         // 如果当前levelMetaData没有id，请检查它是否具有publishedLevelId
         if(!leaderboard)
           leaderboard = levelEditor.currentLevelData.levelMetaData ? levelEditor.currentLevelData.levelMetaData.publishedLevelId : undefined

         // 关卡已经发布了
         if(leaderboard) {
           // 报告得分
           gameNetwork.reportScore(time, leaderboard, null, "lowest_is_best")
         }
       }

       // 初始化关卡加载级别后调用此函数
       function initLevel() {

         editorOverlay.initEditor()


         if(bgImage.loadedBackground && bgImage.loadedBackground != -1)
           bgImage.bg = bgImage.loadedBackground
         else
           bgImage.bg = 0

         camera.zoom = 1
         camera.freePosition = Qt.point(0, 0)

         player.initialize()

         player.resetContacts()

         controller.xAxis = 0

         time = 0
         levelTimer.restart()
       }


       function resetLevel() {

         editorOverlay.resetEditor()

         player.reset()

         var opponents = entityManager.getEntityArrayByType("opponent")
         for(var opp in opponents) {
           opponents[opp].reset()
         }

         var coins = entityManager.getEntityArrayByType("coin")
         for(var coin in coins) {
           coins[coin].reset()
         }

         var mushrooms = entityManager.getEntityArrayByType("mushroom")
         for(var mushroom in mushrooms) {
           mushrooms[mushroom].reset()
         }

         // 重新开始
         var stars = entityManager.getEntityArrayByType("star")
         for(var star in stars) {
           stars[star].reset()
         }

         // 重置时间和计时器
         time = 0
         levelTimer.restart()
       }

}

