import Felgo 3.0
import QtQuick 2.0


GameWindow {
  id: gameWindow

  activeScene: menuScene  //活动窗口

  screenWidth: 960
  screenHeight: 640

 // property alias levelEditor: levelEditor
  //property alias itemEditor: gameScene.itemEditor

  // update background music when scene changes
  onActiveSceneChanged: {
    audioManager.handleMusic()
  }

  //level editor

  /*MusicManager {             //背景音乐
    id: audioManager
  }*/

  EntityManager {             //通过容器管理实体
    id: entityManager
    entityContainer: gameScene.container
    poolingEnabled: true
  }

   FelgoGameNetwork { //用于在游戏中使用排行榜、成就和挑战的根 Felgo 游戏网络组件。
    id: gameNetwork

    gameId: 220
    secret: "platformerEditorDevPasswordForVPlayGameNetwork"

    // set gameNetworkView
    gameNetworkView: myGameNetworkView
  }

  // custom mario style font
  FontLoader {
    id: marioFont
    source: "../assets/fonts/SuperMario256.ttf"
  }

  // Scenes -----------------------------------------
  MenuScene {
    id: menuScene
   /* onKindsScenePressed: {
      gameWindow.state = "level"
    }*/
  }


  // states
  state: "menu"

  // this state machine handles the transition between scenes
  states: [
    State {
      name: "menu"
      PropertyChanges {target: menuScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: menuScene}
    },
    State {
      name: "level"
      PropertyChanges {target: levelScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: levelScene}
    },
    State {
      name: "game"
      PropertyChanges {target: gameScene; opacity: 1}
      PropertyChanges {target: gameWindow; activeScene: gameScene}
    }
  ]

}

