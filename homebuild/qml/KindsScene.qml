import QtQuick 2.0
import Felgo 3.0
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.0

SceneBase{

    id:kindsScene
    //signals
    signal newLevelPressed
    signal playLevelPressed(var levelData)
    signal editLevelPressed(var levelData)
    signal removeLevelPressed(var levelData)
    signal backPressed
    //当前活动的是选择关卡还是创建关卡
    property var activeKindsGrid
    property string subState: "createdKinds"

    onStateChanged: reloadLevels()
    onSubStateChanged: reloadLevels()

    state: "demoKinds"
    Rectangle {
      id: background
      //gameWindowAnchorItem可用于将 Scene 的直接子项锚定到父 GameWindow ，而不是逻辑 Scene 大小
      anchors.fill: parent.gameWindowAnchorItem
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
                 isSelected: kindsScene.state === "myKinds"
                 onClicked: kindsScene.state = "myKinds"
             }
        }
        //返回首页
         HomeImageButton{
             image.source:"../assets/ui/home.png"
             width: 40
             height: 30
             style: ButtonStyle {
               background: Rectangle {
                 radius: imageButton.radius
                 color: "transparent"
               }
             }
             anchors.verticalCenter: parent.verticalCenter
             anchors.right: parent.right
             anchors.rightMargin: 5
             //发送信号
             onClicked: backPressed()
         }
    }
    Rectangle{
        id:subBar
        state:"created"
        width: parent.gameWindowAnchorItem.width
        height: 40
        color: "transparent"
        anchors.top: mainBar.bottom
        anchors.left: parent.gameWindowAnchorItem.left
        //只有选kinds不选demo的时候才显示这一行
        visible: kindsScene.state==="myKinds"
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
                //发送信号
                onClicked: newLevelPressed()
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
        id:demoKindsGrid
        anchors.margins: 100
        anchors.topMargin: 0
        anchors.bottomMargin: 0
        visible: kindsScene.state==="demoKinds"
        levelMetaDataArray:gameWindow.levelEditor.authorGeneratedLevels

    }
    //display all create kinds
    KindsGrid{
        id: downloadedLevelGrid
        visible: myDownloadedLevelsVisible

        // we only show authorGeneratedLevels
        levelMetaDataArray: gameWindow.levelEditor.downloadedLevels
    }
    function reloadLevels() {
      if(state == "demoKinds") {
        levelEditor.loadAllLevelsFromStorageLocation(levelEditor.applicationJSONLevelsLocation)
        activeLevelGrid = demoLevelGrid
      }
      else if(state == "myKinds") {
        if(subState == "createdKinds") {
          levelEditor.loadAllLevelsFromStorageLocation(levelEditor.authorGeneratedLevelsLocation)
          activeLevelGrid = createdLevelGrid
        }
      }
    }
    //关卡选择

}
