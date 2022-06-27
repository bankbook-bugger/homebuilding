import Felgo 3.0
import QtQuick 2.0
import "../qml/scenes/editorElements/EditorLogic.js" as EditorLogic


Item {
  id: editorOverlay

  property alias grid: grid
  property alias sidebar: sidebar
  property alias itemEditor: itemEditor
  property alias undoHandler: undoHandler

  property var selectedButton

  property var scene: parent

  property var containerComponent: scene.container

  EditorGrid {
    id: grid

    visible: inEditMode

    container: containerComponent
  }

//左侧工具栏
  LeftSidebar {
    id: sidebar

    visible: inEditMode

    bgImage: scene.bgImage
    grid: grid
    undoHandler: undoHandler
  }
//右侧扩展栏
  ItemEditor {
    id: itemEditor


    anchors.right: parent.right
    anchors.top: topbar.bottom
    anchors.bottom: parent.bottom

    opacity: 0.9
  }

  HomeTextButton {
      //右边的扩展属性栏
    id: itemEditorButton

    screenText: itemEditorVisible ? ">" : "<"

    width: 12

    anchors.right: itemEditor.visible ? itemEditor.left : parent.right
    anchors.verticalCenter: parent.verticalCenter

    onClicked: {
      itemEditor.visible = !itemEditor.visible
    }
  }


  HomeImageButton{
      //上部功能按钮
    id: testButton
    width: 50
    height: 30

    anchors.horizontalCenter: editorOverlay.horizontalCenter
    anchors.top: editorOverlay.top

    image.source: inEditMode ? "../../assets/ui/play.png" : "../../assets/ui/edit.png"

    opacity: inEditMode ? 1 : 0.5

    onClicked: {
      if(inEditMode) {
        scene.state = "test"
      }
      else
        scene.state = "edit"
    }
  }

  Row {
    id: topbar

    visible: inEditMode

    height: 30

    anchors.right: editorOverlay.right
    anchors.top: editorOverlay.top

    spacing: 4

    HomeImageButton{  //右上角的保存按钮

      id: saveButton

      width: 40

      image.source: "../../assets/ui/save.png"

      onClicked: {
        saveLevel()

        savedTextAnimation.restart()
      }

      Text {
        text: "saved"
        color: "#ffffff"

        opacity: 0

        anchors.top: saveButton.bottom

        style: Text.Outline
        styleColor: "#009900"
        //保存后的提示动画
        NumberAnimation on opacity {
          id: savedTextAnimation

          from: 1
          to: 0
}

      }


    }

    HomeImageButton{

      id: menuButton

      width: 40

      image.source: "../../assets/ui/home.png"

      onClicked: saveLevelDialog.opacity = 1
    }
  }

  UndoHandler {
    id: undoHandler
  }

  SaveLevelDialog {//保存关卡对话框
    id: saveLevelDialog
  }

  PublishDialog {//准备发布自定义关卡对话框
    id: publishDialog
  }

  //一下功能在js中实现的

  function clickEntity(entity) {
    EditorLogic.clickEntity(entity);
  }

  function removeEntity(entity) {
    return EditorLogic.removeEntity(entity);
  }

  function getMouseGridPos(mouseX, mouseY) {
    return EditorLogic.getMouseGridPos(mouseX, mouseY);
  }


  function isBodyIn32Grid(position) {
    return EditorLogic.isBodyIn32Grid(position);
  }


  function placeEntityAtPosition(mouseX, mouseY) {
    return EditorLogic.placeEntityAtPosition(mouseX, mouseY);
  }


  function mouseToLevelCoordinates(mouseX, mouseY) {
    return EditorLogic.mouseToLevelCoordinates(mouseX, mouseY);
  }


  function snapToGrid(levelX, levelY) {
    return EditorLogic.snapToGrid(levelX, levelY);
  }

}
