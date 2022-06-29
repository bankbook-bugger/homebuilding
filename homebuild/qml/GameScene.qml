import Felgo 3.0
import QtQuick 2.0
import QtQuick.Controls.Styles 1.0

/*
  2020051615113wangmin,wanglingzhi,chenzhexi,
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

  state: "play"

  states: [
    State {
      name: "play"
      StateChangeScript {script: musicManager.handleMusic()}
    },
    State {
      name: "edit"
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
      PropertyChanges {target: editorOverlay; visible: true}
      StateChangeScript {script: musicManager.playSound("start")}
      StateChangeScript {script: musicManager.handleMusic()}
      PropertyChanges {target: gameScene; time: 0}
      //StateChangeScript {script: levelTimer.restart()}
      PropertyChanges {target: camera; zoom: 1}
    },
    State {
      name: "finish"
      PropertyChanges {target: physicsWorld; running: false}
    }
  ]


  BackgroundImage {
    id: bgImage
    anchors.centerIn: parent.gameWindowAnchorItem

    property int bg: 0
    //背景图片的添加以及路径
    property string bg0: "../assets/backgroundImage/background.png"
    property string bg1: "../assets/backgroundImage/background.png"

    property int loadedBackground: {
      if(gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
          && gameWindow.levelEditor.currentLevelData["customData"]
          && gameWindow.levelEditor.currentLevelData["customData"]["background"])
        parseInt(gameWindow.levelEditor.currentLevelData["customData"]["background"])
      else
        -1
    }
    source: bg == 0 ? bg0 : bg1

  }


  EditorUnderlay {
        id: editorUnderlay
      }

      //游戏元素
      Item {
          id: container
          transformOrigin: Item.TopLeft

          PhysicsWorld {    //物理处理
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

                  if(entityA.entityType === "player" && entityB.entityType === "monster"
                          || entityB.entityType === "player" && entityA.entityType === "monster") {
                      contact.enabled = false
                  }
              }

              EditableComponent {      //右边调试整体重力
                  editableType: "Balance"
                  defaultGroup: "Physics"
                  properties: {
                      "gravityY": {"min": 0, "max": 100, "label": "Gravity"}
                  }
              }
          }

          Player {     //玩家
              id: player
              z: 1
              onFinish: {
                  if(gameScene.state == "test")
                      //如果是test状态下赢了，就直接重来，不显示对话框
                      resetLevel()
                  else if(gameScene.state == "play") {
                      //显示对话框
                      gameScene.state = "finish"

                      handleScore()

                      finishDialog.score =score
                      finishDialog.opacity = 1
                  }
              }
          }

          ResetSensor {        //玩家是否die
              player: player
              onContact: {
                  player.die(true)
              }
          }

      }


      //相机设置
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


      MoveTouchButton {
          id: moveTouchButton
          controller: controller
      }


      JumpTouchButton {
          id: jumpTouchButton
      }

      //将键盘键转发到控制器
      Keys.forwardTo: controller

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



      EditorOverlay {
        id: editorOverlay
        visible: false
        scene: gameScene
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


      HomeImageButton {            //菜单按钮
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


      FinishDialog {
          id: finishDialog
      }




      //js实现的功能
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
        var hearts = entityManager.getEntityArrayByType("heart")
        for(var heart in hearts) {
          hearts[heart].reset()
        }
      }
  }

