import QtQuick 2.15

Rectangle {
   width: 768; height: 768
   color:"white"
   property var style
   Item {
       //获取键盘输入的房产=方向键
       anchors.fill: parent
          id: keyHandler
          focus: true
           Keys.onPressed: (event)=> {
              if (event.key === Qt.Key_Left)//左
                 { style="lwalk";flag.start();
                     event.accepted = true;
                               }
              if (event.key ===Qt.Key_Right)//右
                {  style="rwalk";flag.start(); event.accepted = true;}
              if (event.key === Qt.Key_Up)//上
               {   style="rjump";
                 flag.start(); event.accepted = true; }
}}
   //精灵动画
   SequentialAnimation{
   id: flag
   ScriptAction { script: image.goalSprite ="still"; }//最后停止的状态总是站立的形状
   ScriptAction { script: {image.goalSprite = ""; image.jumpTo(style);} }
}
   //精灵表单中每一个动作的大小为100X100
   SpriteSequence {
       id: image; width: 100; height: 100; goalSprite: ""
       anchors.horizontalCenter: parent.horizontalCenter
       Sprite{
           name: "still"; source: "../assets/player/player.png"
           frameCount: 1; frameX:0;frameY:300;frameWidth: 100; frameHeight: 100; frameDuration: 100
            to:{"still":1}
       }

       Sprite{
           name: "ljump"; source:  "../assets/player/player.png"
           frameCount: 1; frameX: 0; frameY: 0; frameWidth: 100; frameHeight: 100
           frameDuration: 100
            to:{"still":1}
       }
       Sprite{
           name: "rjump"; source: "../assets/player/player.png"
           frameCount: 1; frameX: 100; frameY:0; frameWidth: 100; frameHeight: 100
           frameDuration: 500
           to:{"still":1}
       }
       Sprite{
           name: "rwalk"; source:  "../assets/player/player.png"
           frameCount: 4; frameX: 0; frameY: 200; frameWidth: 100; frameHeight: 100
           frameDuration: 100
           to:{"still":1}
       }
       Sprite{
           name: "lwalk"; source:  "../assets/player/player.png"
           frameCount: 4; frameX: 0; frameY: 100; frameWidth: 100; frameHeight: 100
           frameDuration: 500
           to:{"still":1}
       }

       }
}


