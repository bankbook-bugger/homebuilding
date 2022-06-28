import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls.Styles 1.0

/*
  2020051615113wangmin,chenzhexi,wanglingzhi
  function:gameScene
  */

SceneBase {
  id: gameScene
  sceneAlignmentX: "left"
  sceneAlignmentY: "top"
  gridSize: 32

  property int time: 0


  property alias editorOverlay: editorOverlay
  property alias container: container
  property alias player: player
  property alias physicsWorld: physicsWorld
  property alias bgImage: bgImage
  property alias camera: camera
  property alias itemEditor: editorOverlay.itemEditor

  signal backPressed

  state: "play" //默认状态为玩耍状态

  states: [
    State {
      name: "play"
      StateChangeScript {script: audioManager.handleMusic()}
    },
    State {
      name: "edit"
      PropertyChanges {target: physicsWorld; gravity: Qt.point(0,0)}
      PropertyChanges {target: editorUnderlay; enabled: true}
      PropertyChanges {target: editorOverlay; visible: true}
      PropertyChanges {target: editorOverlay; inEditMode: true}
      StateChangeScript {script: resetLevel()}
      StateChangeScript {script: editorOverlay.grid.requestPaint()}
      StateChangeScript {script: audioManager.handleMusic()}
    },
    State {
      name: "test"
      PropertyChanges {target: editorOverlay; visible: true}
      StateChangeScript {script: audioManager.playSound("start")}
      StateChangeScript {script: audioManager.handleMusic()}
      PropertyChanges {target: gameScene; time: 0}
      StateChangeScript {script: levelTimer.restart()}
      PropertyChanges {target: camera; zoom: 1}
    },
    State {
      name: "finish"
      PropertyChanges {target: physicsWorld; running: false}
    }
  ]

  //  游戏场景的背景
  BackgroundImage {
    id: bgImage

    anchors.centerIn: parent.gameWindowAnchorItem
    source: "../assets/ui/background.png"

  }

  EditorUnderlay {
    id: editorUnderlay
  }


  //游戏元素
  Item {
    id: container
    transformOrigin: Item.TopLeft

    PhysicsWorld {              //物理处理
      id: physicsWorld

      property int gravityY: 40
      gravity: Qt.point(0, gravityY)

      debugDrawVisible: false
      z: 1000
      running: true

      onPreSolve: {
        var entityA = contact.fixtureA.getBody().target
        var entityB = contact.fixtureB.getBody().target
        //禁用玩家之间的物理碰撞处理和对手  物理性质不改变

        if(entityA.entityType === "player" && entityB.entityType === "opponent"
            || entityB.entityType === "player" && entityA.entityType === "opponent") {
          contact.enabled = false
        }
      }

      EditableComponent {  //右边调试整体重力
        editableType: "Balance"
        defaultGroup: "Physics"
        properties: {
          "gravityY": {"min": 0, "max": 100, "label": "Gravity"}
        }
      }
    }

    Player {    //玩家
      id: player
      z: 1
      onFinish: {
        if(gameScene.state == "test") //如果是test状态下赢了，就直接重来，不显示对话框
          resetLevel()
        else if(gameScene.state == "play") {
          gameScene.state = "finish"
          handleScore()

          finishDialog.score = time
          finishDialog.opacity = 1
        }
      }
    }

    ResetSensor {           //玩家是否die

      player: player
      onContact: {
        player.die(true)
      }
    }
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


  MoveTouchButton {
    id: moveTouchButton


    controller: controller
  }


  JumpTouchButton {
    id: jumpTouchButton

//    onPressed: player.startJump(true)
//    onReleased: player.endJump()
  }


  Keys.forwardTo: controller

  TwoAxisController {
    id: controller

    enabled: gameScene.state != "edit"


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


    onXAxisChanged: player.changeSpriteOrientation()
  }




  HUDHeart {           //第一条生命显示
      id: heartDisplay1
      heart.source: player.heart>=1?"../assets/ui/red_heart.png":"../assets/ui/black_heart.png"
  }

  HUDHeart {           //第二条生命显示
      id: heartDisplay2
      heart.source:player.heart>=2?"../assets/ui/red_heart.png":"../assets/ui/black_heart.png"
      anchors.left:heartDisplay1.right
  }

  HUDHeart {           //第三条生命显示
      id: heartDisplay3
      heart.source: player.heart>=3?"../assets/ui/red_heart.png":"../assets/ui/black_heart.png"
      anchors.left:heartDisplay2.right
  }

  HUDIconAndText {            //收入(金币)显示
      id: coinDisplay
      text: player.score
      icon.source: "../assets/ui/coin.png"
      anchors.top:heartDisplay1.bottom
  }

  /**
   * TOP BAR
   */

  // back to menu button
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

  /**
   * EDITOR OVERLAY
   */

  EditorOverlay {
    id: editorOverlay

    visible: false

    scene: gameScene
  }

  /**
   * DIALOGS
   */

  FinishDialog {
    id: finishDialog
  }

  /**
   * JAVASCRIPT FUNCTIONS --------------------------------------
   */

  function handleScore() {
    // id only exists in published levels
    var leaderboard = levelEditor.currentLevelData.levelMetaData ? levelEditor.currentLevelData.levelMetaData.id : undefined

    // if current levelMetaData doesn't have an id, check if it has publishedLevelId
    if(!leaderboard)
      leaderboard = levelEditor.currentLevelData.levelMetaData ? levelEditor.currentLevelData.levelMetaData.publishedLevelId : undefined

    // if level is published...
    if(leaderboard) {
      // ...report the score; the lower the score, the better
      gameNetwork.reportScore(time, leaderboard, null, "lowest_is_best")
    }
  }

  // initializes the level
  // this function is called after a level was loaded
  function initLevel() {

    // initialize the editor
    editorOverlay.initEditor()

    // set background image
    // when there is a background saved, load it
    if(bgImage.loadedBackground && bgImage.loadedBackground != -1)
      bgImage.bg = bgImage.loadedBackground
    else // otherwise take the default background
      bgImage.bg = 0

    // reset the camera
    camera.zoom = 1
    camera.freePosition = Qt.point(0, 0)

    // initialize the player
    player.initialize()

    // reset the player's contacts
    player.resetContacts()

    // reset the controller's xAxis to ensure, that it's zero
    // at the beginning of the level
    controller.xAxis = 0

    // reset time and timer
    time = 0
    levelTimer.restart()
  }

  // resets the level
  // this function is i.a. called everytime the player dies, or the user
  // switches from test to edit mode
  function resetLevel() {

    // reset the editor
    editorOverlay.resetEditor()

    // reset player
    player.reset()

    // reset opponents
    var opponents = entityManager.getEntityArrayByType("opponent")
    for(var opp in opponents) {
      opponents[opp].reset()
    }

    // reset coins
    var coins = entityManager.getEntityArrayByType("coin")
    for(var coin in coins) {
      coins[coin].reset()
    }

    // reset mushrooms
    var mushrooms = entityManager.getEntityArrayByType("mushroom")
    for(var mushroom in mushrooms) {
      mushrooms[mushroom].reset()
    }

    // reset stars
    var stars = entityManager.getEntityArrayByType("star")
    for(var star in stars) {
      stars[star].reset()
    }

    // reset time and timer
    time = 0
    levelTimer.restart()
  }
}
