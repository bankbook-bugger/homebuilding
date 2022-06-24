import Felgo 3.0
import QtQuick 2.0
import "../qml/scenes/editorElements/EditorLogic.js" as EditorLogic


Item {
  id: editorOverlay

  // make components accessible from the outside
  property alias grid: grid
  property alias sidebar: sidebar
  property alias itemEditor: itemEditor
  property alias undoHandler: undoHandler

  property var selectedButton

  property var scene: parent

  property var containerComponent: scene.container



  // makes accessing the gameScene's container easier



  property bool itemEditorVisible: false

  property bool inEditMode: false
  visible: false

  anchors.fill: scene.gameWindowAnchorItem

  EditorGrid {
    id: grid

    visible: inEditMode

    container: containerComponent
  }


  /**
   * SIDEBAR --------------------------------------
   */
  Sidebar {
    id: sidebar

    visible: inEditMode

    // set all components, that can be accessed in the sidebar
    bgImage: scene.bgImage
    grid: grid
    undoHandler: undoHandler
  }


  /**
   * Item editor ----------------------------------
   */
  // item editor for balancing the game
  ItemEditor {
    id: itemEditor

    // invisible by default
    visible: false

    anchors.right: parent.right
    anchors.top: topbar.bottom
    anchors.bottom: parent.bottom

    opacity: 0.9
  }

  HomeTextButton {
      //右边的扩展属性栏
  // button to show/hide itemEditor

    id: itemEditorButton

    screenText: itemEditorVisible ? ">" : "<"

    width: 12

    // if the item editor is visible, anchor this button to the left of the editor;
    // otherwise anchor it to the game window
    anchors.right: itemEditor.visible ? itemEditor.left : parent.right
    anchors.verticalCenter: parent.verticalCenter

    onClicked: {
      itemEditor.visible = !itemEditor.visible
    }
  }


  HomeImageButton{
      //上部功能按钮
  /**
   * TOP BAR --------------------------------------
   */

  // this button enables switching between edit and test mode

    id: testButton

    width: 50
    height: 30

    anchors.horizontalCenter: editorOverlay.horizontalCenter
    anchors.top: editorOverlay.top

    image.source: inEditMode ? "../../assets/ui/play.png" : "../../assets/ui/edit.png"

    opacity: inEditMode ? 1 : 0.5

    // place on top, centered
    anchors.horizontalCenter: editorOverlay.horizontalCenter
    anchors.top: editorOverlay.top

    // set image source, depending on if we're in edit mode
    image.source: inEditMode ? "../../assets/ui/play.png" : "../../assets/ui/edit.png"

    // set opacity to 0.5 when in test mode, to be less distracting
    opacity: inEditMode ? 1 : 0.5

    // set game state depending on current game state
    onClicked: {
      if(inEditMode) {
        scene.state = "test"
      }
      else
        scene.state = "edit"
    }
  }

  // this row holds the buttons in the top right corner
  Row {
    id: topbar

    visible: inEditMode

    height: 30

    anchors.right: editorOverlay.right
    anchors.top: editorOverlay.top

    spacing: 4

    HomeImageButton{  //右上角的保存按钮
    // save level button
    PlatformerImageButton {
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

        // save level
        saveLevel()

        // show saved text
        savedTextAnimation.restart()
      }

      // this text signals, that the level has been saved
      Text {
        // text and text color
        text: "saved"
        color: "#ffffff"

        // by default this text is opaque/invisible
        opacity: 0

        // anchor to the bottom of the save button
        anchors.top: saveButton.bottom

        // outline the text, to increase it's visibility
        style: Text.Outline
        styleColor: "#009900"

        // this animation shows and slowly fades out the save text
        NumberAnimation on opacity {
          id: savedTextAnimation

          // slowly reduce opacity from 1 to 0
          from: 1
          to: 0

          // duration of the animation, in ms
          duration: 2000
        }
      }
    }

    HomeImageButton{

      id: menuButton

      width: 40

      image.source: "../../assets/ui/home.png"

      // open save dialog when in edit mode
      onClicked: saveLevelDialog.opacity = 1
    }
  }


  /**
   * MISC
   */

  // for handling undo and redo
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
  /**
   * DIALOGS
   */

  // this is the save dialog that pops up, when the user clicks
  // the backButton in edit mode
  SaveLevelDialog {
    id: saveLevelDialog
  }

  PublishDialog {
    id: publishDialog
  }

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


  // saves the current level
  function saveLevel() {
    EditorLogic.saveLevel();
  }

  function initEditor() {
    EditorLogic.initEditor();
  }

  function resetEditor() {
    EditorLogic.resetEditor();
  }
}
