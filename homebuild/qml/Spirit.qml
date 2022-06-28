import QtQuick 2.15

Rectangle {
   width: 768; height: 768
   color:"white"
   property int type:0
   property var style
   Item {
       anchors.fill: parent
          id: keyHandler
          focus: true
           Keys.onPressed: (event)=> {
              if (event.key === Qt.Key_Left)
                 { style="lwalk";type+=1;flag.start();
                     event.accepted = true;
                               }
              if (event.key ===Qt.Key_Right)
                {  style="rwalk";type+=2;flag.start(); event.accepted = true;}
              if (event.key === Qt.Key_Up)
               {   style="rjump";
                 flag.start(); event.accepted = true;

          }
}}

   SequentialAnimation{
   id: flag
   ScriptAction { script: image.goalSprite ="still"; }
   ScriptAction { script: {image.goalSprite = ""; image.jumpTo(style);} }
}


   SpriteSequence {
       id: image; width: 100; height: 100; goalSprite: ""
       anchors.horizontalCenter: parent.horizontalCenter
       Sprite{
           name: "still"; source: "player.png"
           frameCount: 1; frameX:0;frameY:300;frameWidth: 100; frameHeight: 100; frameDuration: 100
            to:{"still":1}
       }

       Sprite{
           name: "ljump"; source: "player.png"
           frameCount: 1; frameX: 0; frameY: 0; frameWidth: 100; frameHeight: 100
           frameDuration: 100
            to:{"still":1}
       }
       Sprite{
           name: "rjump"; source: "player.png"
           frameCount: 1; frameX: 100; frameY:0; frameWidth: 100; frameHeight: 100
           frameDuration: 500
           to:{"still":1}
       }
       Sprite{
           name: "rwalk"; source: "player.png"
           frameCount: 4; frameX: 0; frameY: 200; frameWidth: 100; frameHeight: 100
           frameDuration: 100
           to:{"still":1}
       }
       Sprite{
           name: "lwalk"; source: "player.png"
           frameCount: 4; frameX: 0; frameY: 100; frameWidth: 100; frameHeight: 100
           frameDuration: 500
           to:{"still":1}
       }

       }
}


