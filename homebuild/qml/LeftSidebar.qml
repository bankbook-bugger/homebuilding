/*2022.6.24
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

//qml  侧边栏的总qml 整个qml为一个多分辨的图像类型

MultiResolutionImage {
  id: sidebar

  //默认情况下 为手(鼠标)  手为拖动画布  侧边栏里手的图标
  property string activeTool: "hand"

  // 访问游戏场景
  property var bgImage
  property var grid
  property var undoHandler    //撤销按钮

  //左边所有种类的button
  property var buttons: [groundButton, ground2Button, platformButton, spikeballButton, spikesButton, opponentJumperButton, opponentWalkerButton, coinButton, mushroomButton, starButton, finishButton]

  // 外部访问网格的button大小
  property alias gridSizeButton: gridSizeButton

  z: 100 // 确保网格在所有之上
  width: 100
  height: editorOverlay.height
  anchors.top: editorOverlay.top
  anchors.left: editorOverlay.left

  //侧边栏的背景
  source: "../assets/ui/sidebar.png"

  //整体纵向布局 侧边栏
  Item {
    anchors.fill: parent
    anchors.margins: 4

    Row {                      //撤销按钮横排布局
      id: undoRedo
      width: parent.width
      height: 30

      anchors.top: parent.top
      anchors.left: parent.left
      spacing: 2

      property int buttonWidth: width / 2 - spacing / 2


      HomeImageButton {             //撤销按钮
        width: parent.buttonWidth

        //检测是否能撤销 如果可以为蓝色 如果不能撤销(没有可以撤销的)为灰色
        image.source: undoHandler.pointer >= 0 ? "../assets/ui/undo.png" : "../assets/ui/undo_grey.png"

        //保持按钮看见
        hoverRectangle.visible: undoHandler.pointer >= 0 ? true : false
        onClicked: undoHandler.undo()  //undohandler类型的撤回函数

      }

      HomeImageButton {             //重做按钮
        width: parent.buttonWidth

        //检测是否能撤销 如果可以为蓝色 如果不能撤销(没有可以撤销的)为灰色
        image.source: undoHandler.pointer < undoHandler.undoArray.length - 1 ? "../assets/ui/redo.png" : "../assets/ui/redo_grey.png"

        // 无法重做时 要隐形此按钮
        hoverRectangle.visible: undoHandler.pointer < undoHandler.undoArray.length - 1 ? true : false

        onClicked: undoHandler.redo() //undohandler类型的重做函数
      }
    }

    Row {                      //编辑和手(拖动画布)时的按钮布局
      id: tools

      width: parent.width
      height: 30

      anchors.top: undoRedo.bottom
      anchors.left: parent.left
      anchors.topMargin: 4
      spacing: 2
      property int buttonWidth: width / 2 - spacing / 2


      HomeSelectableImageButton {         //编辑界面 擦出按钮或则填写按钮
        id: drawEraseButton

        property bool drawActive: true  //此时为编辑状态 有时为擦除状态

        width: parent.buttonWidth
        height: parent.height

        //查看活动状态 显示图像
        image.source: drawActive ? "../assets/ui/drawActive.png" : "../assets/ui/eraseActive.png"

        onClicked: {  //绘制和擦除模式之间切换
          if(isSelected) {
            drawActive = !drawActive
          }
          else {              //否则为手按钮(非编辑模式 最开始的手
                              //拖动画布状态)被选择
            handButton.isSelected = false
            isSelected = true
          }

          updateActiveTool()         //更新活动状态

          //没有实例创建情况
          if(drawActive && editorOverlay.selectedButton == null) {
            // ...switch to the first entity group...
            changeActiveEntityGroup(1)

            // ...and select the groundButton
            selectBuildEntityButton(groundButton)
          }
        }
      }

      HomeSelectableImageButton {         //手界面 拖动画布按钮
        id: handButton
        width: parent.buttonWidth
        height: parent.height

        image.source: "../assets/ui/hand.png"

        isSelected: true

        onClicked: {
          if(!isSelected) {  //如果没有在编辑状态 则在手的状态
            drawEraseButton.isSelected = false
            isSelected = true
          }
          updateActiveTool()    //更新活动状态
        }

      }

    }

    Row {                      //具体地图的设置布局 三组的首按钮
      id: entityGroups
      width: parent.width
      height: 30

      anchors.top: tools.bottom
      anchors.left: parent.left
      anchors.topMargin: 4
      spacing: 2

      property int activeGroup: 1      //活动的编辑组只能有一个

      //设置按钮宽度  一共有三组
      property int buttonWidth: width / 3 - spacing * 2 / 3

      ItemGroupButton {        //第一组
        image.source: "../assets/ui/entityGroups/group1.png"

        selected: entityGroups.activeGroup == 1
        onClicked: changeActiveEntityGroup(1)
      }

      ItemGroupButton {       //第二组
        image.source: "../assets/ui/entityGroups/group2.png"

        selected: entityGroups.activeGroup == 2
        onClicked: changeActiveEntityGroup(2)
      }

      ItemGroupButton {        //第三组
        image.source: "../assets/ui/entityGroups/group3.png"

        selected: entityGroups.activeGroup == 3
        onClicked: changeActiveEntityGroup(3)
      }
    }


    Flickable {           // 滚动组件类型 包含了整个场景的建设和版本的设置
      id: buildFlickable

      width: parent.width

      anchors.top: entityGroups.bottom
      anchors.bottom: optionsButton.top
      anchors.left: parent.left
      anchors.topMargin: 4
      anchors.bottomMargin: 4

      contentWidth: width         //整体内容的大小
      contentHeight: buildColumn.height

      topMargin: 5
      bottomMargin: 5

      clip: true

      flickableDirection: Flickable.VerticalFlick  //垂直翻转
      pressDelay: 100                  //按钮延迟

      Column {                       //整个内容垂直布局
        id: buildColumn
        width: parent.width
        spacing: 5

        Item {                    //编辑版本的模式 修改当前版本的名字
          id: levelNameItem
          width: parent.width
          height: 30
          visible: entityGroups.activeGroup == 0

          Text {                 //当前级别的名字

            text: levelEditor.currentLevelName ? levelEditor.currentLevelName : ""

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.right: nameLevelButton.left
            anchors.rightMargin: 4

            verticalAlignment: Text.AlignVCenter  //垂直居中
            fontSizeMode: Text.Fit
            font.pixelSize: 13
            minimumPixelSize: 7
          }

          HomeImageButton {   //改名字的按钮
            id: nameLevelButton

            image.source: "../assets/ui/edit_black.png"
            width: 30
            height: parent.height
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom

            onClicked: {            //单击开始改动按钮
              nativeUtils.displayTextInput("Enter levelName", "Enter a level name. (max 15 characters)", "", levelEditor.currentLevelName)
            }

            Connections {           //查看对话框是否结束
              target: nativeUtils

              onTextInputFinished: {
                if(accepted) {
                    //限制输入长度
                  if(enteredText.length > 15) {
                    nativeUtils.displayMessageBox("Invalid level name", "A maximum of 15 characters is allowed!")
                    return
                  }

                  // 使得修改的名字为当前名字
                  levelEditor.currentLevelName = enteredText
                }
              }
            }
          }
        }

        Item {            //网格选项
          id: gridOptions
          width: parent.width
          height: 30
          visible: entityGroups.activeGroup == 0

          Text {                  //网格大小文本
            height: parent.height

            anchors.top: parent.top
            anchors.left: parent.left

            text: "网格大小:"
            font.pixelSize: 12

            verticalAlignment: Text.AlignVCenter
          }


          HomeTextButton {          //网格button
            id: gridSizeButton
            screenText: "32"       //默认为32
            width: 30
            height: parent.height
            anchors.top: parent.top
            anchors.right: parent.right

            onClicked: {           //单击切换网格大小16与32切换
              if(screenText == "32") {
                screenText = "16"
                editorOverlay.scene.gridSize = 16
              }
              else {
                screenText = "32"
                editorOverlay.scene.gridSize = 32
              }
            }
          }

        }

        HomeTextButton {            // 发布按钮
          id: publishButton
          screenText: "发布"
          width: parent.width
          height: 30
          visible: entityGroups.activeGroup == 0

          onClicked: {       //单击使得发布按钮可见性
            publishDialog.opacity = 1
          }
        }



        /*三组里面的内容  编辑地图模式*/
        HomeBuildEntityButton {           //草地button 第一个
          id: groundButton

          //每个按钮仅在相应的实体组  才处于活动状态
          visible: entityGroups.activeGroup == 1
          toCreateEntityTypeUrl: "/GroundGrass.qml"

          // 处理按钮是否被选择
          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {           //草地里面button 第二个
          id: ground2Button

          //每个按钮仅在相应的实体组  才处于活动状态
          visible: entityGroups.activeGroup == 1
          toCreateEntityTypeUrl: "GroundDirt.qml"

          // 处理按钮是否被选择
          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {           //平地button 顶上
          id: platformButton

          //每个按钮仅在相应的实体组  才处于活动状态
          visible: entityGroups.activeGroup == 1
          toCreateEntityTypeUrl: "Platform.qml"

          // 处理按钮是否被选择
          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {           //主攻球的button
          id: spikeballButton

          visible: entityGroups.activeGroup == 1
          toCreateEntityTypeUrl: "Spikeball.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {          //地上攻球的button
          id: spikesButton

          visible: entityGroups.activeGroup == 1

          toCreateEntityTypeUrl: "/Spikes.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        //场景2

        HomeBuildEntityButton {          //跳起来攻击的button
          id: opponentJumperButton

          visible: entityGroups.activeGroup == 2
          toCreateEntityTypeUrl: "OpponentJumper.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {          //走路攻击的button
          id: opponentWalkerButton

          visible: entityGroups.activeGroup == 2
          toCreateEntityTypeUrl: "OpponentWalker.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        //场景3

        HomeBuildEntityButton {           //金币button
          id: coinButton

          visible: entityGroups.activeGroup == 3
          toCreateEntityTypeUrl: "Coin.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {           //蘑菇button
          id: mushroomButton

          visible: entityGroups.activeGroup == 3
          toCreateEntityTypeUrl: "Mushroom.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {             //星星button
          id: starButton

          visible: entityGroups.activeGroup == 3
          toCreateEntityTypeUrl: "../entities/Star.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }

        HomeBuildEntityButton {             //完成button
          id: finishButton

          visible: entityGroups.activeGroup == 3
          toCreateEntityTypeUrl: "/Finish.qml"

          onSelected: selectBuildEntityButton(this)
          onUnselected: unselectBuildEntityButton()
        }


      }

    }

      // 选项按钮 设置当前编辑界面 网格的大小和当前版本的名字
    ItemGroupButton {

      id: optionsButton

      width: 30
      height: 25
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      image.source: "../assets/ui/options.png"

      selected: entityGroups.activeGroup == 0 //此时所有组的button不活动

      onClicked: changeActiveEntityGroup(0)   //切换编辑界面的情况和设置整个版本的情况
    }
  }




  //javascript 的功能函数


  // 处理构建场景为擦出还是 画图
  function selectBuildEntityButton(button) {
    if(activeTool == "erase") {
      setActiveTool("draw")
    }
    unselectAllButtonsButOne(button)
  }

  function unselectBuildEntityButton() {
    // if active tool is draw or erase, change to hand
    if(activeTool == "draw" || activeTool == "erase") {
      setActiveTool("hand")
    }

    editorOverlay.selectedButton = null    //重置选择按钮
  }

  // 取消选择所有构建按钮
  function unselectAllButtons() {
    for(var i=0; i<buttons.length; i++) {
      buttons[i].isSelected = false
    }

    editorOverlay.selectedButton = null    //重置选择按钮
  }


  //非选择所有按钮时  至少选择一个
  function unselectAllButtonsButOne(button) {
    unselectAllButtons()
    if(button) {
      button.isSelected = true

      editorOverlay.selectedButton = button
    }
  }


  //改变活动场景
  function changeActiveEntityGroup(newGroup) {
    if(entityGroups.activeGroup !== newGroup) {
      entityGroups.activeGroup = newGroup
    }
  }

  //更新此活动场景的工具和按钮
  function updateActiveTool() {
    if(drawEraseButton.isSelected) {
      if(drawEraseButton.drawActive) {
        activeTool = "draw"
      }
      else {
        activeTool = "erase"
      }
    }
    else if(handButton.isSelected) {
      activeTool = "hand"
    }
    else {
      activeTool = ""
    }
  }

  // 根据活动场景选择的不同
  function setActiveTool(tool) {
    if(tool === "draw") {
      handButton.isSelected = false
      drawEraseButton.isSelected = true
      drawEraseButton.drawActive = true
    }
    else if(tool === "erase") {
      handButton.isSelected = false
      drawEraseButton.isSelected = true
      drawEraseButton.drawActive = false
    }
    else if(tool === "hand") {
      drawEraseButton.isSelected = false
      handButton.isSelected = true
    }

    updateActiveTool()
  }

  //重置设置场景
  function reset() {
    unselectAllButtons()

      //首页活动场景
    changeActiveEntityGroup(1)

    drawEraseButton.drawActive = true
  }
}