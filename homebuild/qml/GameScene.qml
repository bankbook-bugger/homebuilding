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
       property string activeLevelFileName
       property variant activeLevel

     sceneAlignmentX: "left"
     sceneAlignmentY: "top"

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
            z:40
         anchors.fill: parent.gameWindowAnchorItem
         anchors.centerIn: parent.gameWindowAnchorItem
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
       //以下是人对屏幕的操作
       EditorUnderlay {
         id: editorUnderlay
       }
       Camera {
         id: camera

         // set the gameWindowSize and entityContainer with which the camera works with
         gameWindowSize: Qt.point(gameScene.gameWindowAnchorItem.width, gameScene.gameWindowAnchorItem.height)
         entityContainer: container

         // disable the camera's mouseArea, since we handle the controls of the free
         // moving camera ourself, in EditorUnderlay
         mouseAreaEnabled: false

         // the camera follows the player when not in edit mode
         focusedObject: gameScene.state != "edit" ? player : null

         // set focused offset
         focusOffset: Qt.point(0.5, 0.3)

         // set limits
         limitLeft: 0
         limitBottom: 0

         // set free camera offset, if sidebar is visible
         freeOffset: gameScene.state != "edit" ? Qt.point(0, 0) : Qt.point(100, 0)
       }
       EditorOverlay {
         id: editorOverlay

         visible: false

         scene: gameScene
       }

}

