import Felgo 3.0
import QtQuick 2.0


GameWindow {
  id: gameWindow

  activeScene: menuScene  //活动窗口

  screenWidth: 960
  screenHeight: 640


 // property alias levelEditor: levelEditor
  //property alias itemEditor: gameScene.itemEditor

  onActiveSceneChanged: {     //活动场景改变更改背景音乐
    musicManager.handleMusic()
  }

  MusicManager {
    id: musicManager
  }




  EntityManager {             //通过容器管理实体 所创建的实体在里面
    id: entityManager
//    entityContainer: gameScene.container
    entityContainer: gameScene
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

  // Scenes -----------------------------------------
  GameScene{
      id:gameScene
      visible: false
      Row{
          id:buildEntityButton
          visible: false
          HomeBuildEntityButton{
          anchors.fill: image1
          Image {
              id: image1
  //            source: "file"
          }
          }
          HomeBuildEntityButton{
          anchors.fill: image2
          Image {
              id: image2
  //            source: "file"
          }}

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
        // load level
        levelEditor.loadSingleLevel(levelData)

        // switch to gameScene, play mode
        gameWindow.state = "game"
        gameScene.state = "play"

        // initialize level
        gameScene.initLevel()
      }
      onBackPressed: {
        gameWindow.state = "menu"
      }
  }


  // 当前状态
  state: "menu"

  // 场景状态切换
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "kinds"
      PropertyChanges {target: kindsScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: kindsScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]

}

