import Felgo 3.0
import QtQuick 2.0
/*
  2020051615113wangmin
  function:gameScene
  */
SceneBase {
    id:gameScene

       property string activeLevelFileName
       property variant activeLevel

       function setLevel(fileName) {
         activeLevelFileName = fileName
       }
       // 游戏场景的背景
       BackgroundImage {
         id: bgImage

         anchors.centerIn: parent.gameWindowAnchorItem
         property int bg: 0
         property string bg0: "../../assets/backgroundImage/bg.png"
         source: bg0
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
       MoveButton {
         id: moveTouchButton
         controller: controller
       }
       JumpButton {
         id: jumpTouchButton
         onPressed: player.startJump(true)
         onReleased: player.endJump()
       }


}
