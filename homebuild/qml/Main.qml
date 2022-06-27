/*2022.6.24
  wanglingzhi*/

import Felgo 3.0
import QtQuick 2.0


GameWindow {
  id: gameWindow

  activeScene: menuScene  //活动窗口
  screenWidth: 960
  screenHeight: 640


  property alias levelEditor: levelEditor
  //property alias itemEditor: gameScene.itemEditor

  onActiveSceneChanged: {     //活动场景改变更改背景音乐
    musicManager.handleMusic()
  }
  LevelEditor {
    id: levelEditor

    Component.onCompleted: levelEditor.loadAllLevelsFromStorageLocation(authorGeneratedLevelsLocation)

    //这些是entityManager可以存储和删除的实体类型。
    //请注意，玩家不在这里。这是因为我们
    //想要一个玩家实例-我们不想
    //其他玩家或删除现有玩家。
    toRemoveEntityTypes: [ "ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish" ]
    toStoreEntityTypes: [ "ground", "platform", "spikes", "opponent", "coin", "mushroom", "star", "finish" ]

    // set the gameNetwork
    //gameNetworkItem: gameNetwork

    // directory where the predefined json levels are
    //applicationJSONLevelsDirectory: "levels/"

    onLevelPublished: {
      // save level
      gameScene.editorOverlay.saveLevel()

      //report a dummy score, to initialize the leaderboard
      var leaderboard = levelId
      if(leaderboard) {
        gameNetwork.reportScore(100000, leaderboard, null, "lowest_is_best")
      }

      gameWindow.state = "level"
    }
  }

  MusicManager {
    id: musicManager
  }


  EntityManager {             //通过容器管理实体 所创建的实体在里面
    id: entityManager
    entityContainer: gameScene.container
    poolingEnabled: true
  }


   FelgoGameNetwork { //用于在游戏中使用排行榜、成就和挑战的根 Felgo 游戏网络组件。
    id: gameNetwork
    gameId: 220
    secret: "platformerEditorDevPasswordForVPlayGameNetwork"

    gameNetworkView: myGameNetworkView  //使用预定义的UI
  }


  FontLoader {    //定义字体样式
    id: marioFont
    source: "../assets/fonts/SuperMario256.ttf"
  }

  GameScene{                        //游戏场景
      id:gameScene
      onBackPressed: {
           console.debug("1")
        gameScene.resetLevel()
        console.debug("1")
        gameWindow.state = "kinds"
      }
  }

  MenuScene {                             //菜单场景
    id: menuScene
    onKindsScenePressed: {      //kinds的槽函数
      gameWindow.state = "kinds"
    }
  }

  KindsScene{                             //类型场景
      id:kindsScene

      onNewLevelPressed: {    //创建种类
          console.log("hhhhhhh")
        var creationProperties = {
          levelMetaData: {
            levelName: "newLevel"
          }
        }
        levelEditor.createNewLevel(creationProperties)

        gameWindow.state = "game"
        gameScene.state = "edit"

        gameScene.initLevel()
      }

      onPlayLevelPressed: {

        //levelEditor.loadSingleLevel(levelData)
        gameWindow.state = "game"
        gameScene.state = "play"
        gameScene.initLevel()
      }
      onBackPressed: {
        gameWindow.state = "menu"
      }
  }
  // 当前状态

  state:"menu"

  // 场景状态切换
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },      // if the player collides with the reset sensor, he dies
    State {
      name: "kinds"
      PropertyChanges {target: kindsScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: kindsScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: menuScene; opacity: 0}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]
  MusicManager {
    id: audioManager
  }

}

