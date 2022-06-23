import QtQuick 2.0
import Felgo 3.0

SceneBase{
    id:kindsScene
    Rectangle {
      id: background
      //gameWindowAnchorItem可用于将 Scene 的直接子项锚定到父 GameWindow ，而不是逻辑 Scene 大小
      anchors.fill: parent.gameWindowAnchorItem

      //color: "#F4A460"
      color: "#FFE4A5"
    }
    Rectangle{
        id:mainBar
        width: parent.gameWindowAnchorItem.width
        height: 40
        color: "transparent"
        anchors.top: parent.gameWindowAnchorItem.top
        anchors.left: parent.gameWindowAnchorItem.left
        Row{
            height: 30
            anchors.centerIn: parent
            spacing: 5
            //demo
             HomeSelectableTextButton{
                id:demoKinds
                screenText: "Demos"
                width: 80
                isSelected: kindsScene.state==="demoKinds"
                onClicked: kindsScene.state="demoKinds"
             }
            //编辑关卡
             HomeSelectableTextButton{
                 id: myKinds
                 screenText: "My Levels"
                 width: 80
                 isSelected: levelScene.state === "myLevels"
                 onClicked: levelScene.state = "myLevels"
             }
        }
        //返回首页
         HomeSelectableImageButton{
             image.source:"../assets/ui/home.png"
             width: 40
             height: 30
             anchors.verticalCenter: parent.verticalCenter
             anchors.right: parent.right
             anchors.rightMargin: 5
             //onClicked: backPressed()
         }
    }
    Rectangle{
        id:subBar
        width: parent.gameWindowAnchorItem.width
        height: 40
        color: "transparent"
        anchors.top: mainBar.bottom
        anchors.left: parent.gameWindowAnchorItem.left
        //只有选kinds不选demo的时候才显示这一行
        //visible: mykindssVisible
        //anchors.topMargin: -1
        Row{
            height: 30
            anchors.centerIn: parent
            spacing: 5
            //visible: mykindssVisible
            //new
            HomeImageButton{
                id: newLevelButton
                width: 50
                height: 30
                image.source: "../assets/ui/add.png"
                //onClicked: newLevelPressed()
            }
            //show created
            HomeSelectableTextButton{
                id: createdLevelsButton
                screenText: "Created"
                width: 80
                isSelected: subState === "createdKinds"
                onClicked: subState = "createdKinds"}
        }
    }
    //show all demos
    KindsGrid{

    }
    //display all create kinds
    KindsGrid{}
    state: "demokinds"
    states: [
        State{
            name:"demokinds"
            PropertyChanges {
                target: subBar

            }
        },
        State{
            name: "mykinds"
            PropertyChanges {
                target: subBar

            }
        }
    ]
}
