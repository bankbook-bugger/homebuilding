/*2022.6.23
  wanglingzhi*/

import QtQuick 2.0
import QtQuick 2.15
import Felgo 3.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.0

Scene {
    id: menuScene

    signal kindsScenePressed

    Rectangle {            //整体背景
        id:background
        anchors.fill: parent.gameWindowAnchorItem
        color:"#FFE4A5"
    }

    Rectangle{            //游戏名字 logo
        id: header
        height: 95
        anchors.top: menuScene.gameWindowAnchorItem.top
        anchors.left: menuScene.gameWindowAnchorItem.left
        anchors.right: menuScene.gameWindowAnchorItem.right
        anchors.margins: 5


        color: "#cce6ff"    // 背景颜色 圆角
        radius: height / 4

        MultiResolutionImage {   //多分辨率图像类  logo设置
          fillMode: Image.PreserveAspectFit  //用适合图片大小的合适充满的属性
          anchors.top: parent.top
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.topMargin: 10

          source: "../assets/ui/name.png"
        }

    }

    HomeImageButton {               //通过写的基类设置开始游戏按钮
      id: playButton

      image.source: "../assets/ui/start.png"
      width: 120
      height: 50

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: header.bottom
      anchors.topMargin: 40

      radius: height / 4

      style:ButtonStyle{
          background:  Rectangle {
              radius: imageButton.radius
              color: "transparent"
            }
      }

      onClicked: {
        kindsScene.state = "demoKinds"
        kindsScenePressed()
      }
    }


    HomeImageButton {               //通过写的基类设置设置游戏按钮
      id: kindsSceneButton

      image.source: "../assets/ui/set.png"
      width: 120
      height: 50

      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: playButton.bottom
      anchors.topMargin: 40

      radius: height / 4
      style:ButtonStyle{
          background:  Rectangle {
              radius: imageButton.radius
              color: "transparent"
            }
      }
      /*onClicked: {
      levelScene.state = "myLevels"
      levelScene.subState = "createdLevels"
      levelScenePressed()  //KindsScenePressed
    }
      }*/
    }

    MultiResolutionImage {         //通过多分辨率图像类 写出音乐按钮
      id: musicButton

      source: "../assets/ui/music.png"
      opacity: settings.musicEnabled ? 0.9 : 0.4 //透明度

      anchors.top: header.bottom
      anchors.topMargin: 30
      anchors.left: parent.left
      anchors.leftMargin: 30

      TapHandler {
        onTapped: {
          if(settings.musicEnabled)  //查看背景音乐是否播放
            settings.musicEnabled = false
          else
            settings.musicEnabled = true
        }
      }
    }

    MultiResolutionImage {         //通过多分辨率图像类 写出音效按钮
      id: soundButton

      source: settings.soundEnabled ? "../assets/ui/sound_on.png" : "../assets/ui/sound_off.png"         //切换不同状态的图片
      opacity: settings.soundEnabled ? 0.9 : 0.4  //减少透明度

      anchors.top: musicButton.bottom
      anchors.topMargin: 10
      anchors.left: parent.left
      anchors.leftMargin: 30

      TapHandler {
        onTapped: {
          if(settings.soundEnabled) { //查看背景音效是否播放
            settings.soundEnabled = false
          }
          else {
            settings.soundEnabled = true
            audioManager.playSound("playerJump")
          }
        }
      }

    }


}

