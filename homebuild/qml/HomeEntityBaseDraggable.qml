/*2022.6.24
  chenzexi wanglingzhi */

import QtQuick 2.15
import Felgo 3.0

EntityBaseDraggable{
    id:entityBase
    //当前实体在哪个场景中
    property var scene:gameScene
    //实体的图片
    property alias image:sprite
    //实体拖动到的最后的位置
    property point lastPosition
    Component.onCompleted: lastPosition=Qt.point(x,y)
    width:sprite.width
    height:sprite.height
    //gridSize是什么？？
    gridSize: scene.gridSize
//    TapHandler{
//        onLongPressed: {
//            if(scene.editorOverlay.sidebar.activeTool === "hand") {
//              mouse.accepted = false
//            }
//        }
//    }
    selectionMouseArea {
      anchors.fill: sprite
      onPressed: {
        if(scene.editorOverlay.sidebar.activeTool == "hand") {
          mouse.accepted = false
        }
      }
    }
    MultiResolutionImage{
        id:sprite
    }
    //仅当此属性设置为 true 时，才允许拖动和单击
    inLevelEditingMode: scene.state === "edit"

    // 此点属性保存在关卡中拖动实体时应应用的偏移量。  默认偏移量设置为 Qt.point(0,-70)。  这意味着当实体被拖动时，它会从初始按下位置向上移动 70 个像素。  这在移动设备上尤其需要，因为否则实体将在手指下不可见。  在使用鼠标定位的桌面平台上，此偏移量可能设置为 Qt.point(0,0)。

    dragOffset: Qt.point(0, 0)

    // 如果您希望 EntityBaseDraggable::dragOffset 延迟到实际拖动开始，而不是在实体被按下时应用，则将此设置为 true
    delayDragOffset: true
    //在不允许构建的时候显示，默认指向一个红色矩形的别名
    notAllowedRectangle.anchors.fill: sprite //可以运行

    // 使用此实体在 EntityManager 中进行池化使用此实体在 EntityManager 中进行池化
    poolingEnabled: true

    // 可以把实体拖拽到边框之外
    ignoreBounds: true

    // entityBase是啥？？？？？
    onEntityClicked: scene.editorOverlay.clickEntity(entityBase)
    //entity的State是什么？？
    onEntityStateChanged: {
      if(entityState == "entityDragged")
        musicManager.playSound("dragEntity")
    }

    onEntityReleased: {
        //创建的位置x<0就无事发生
      if(lastPosition.x < 0) return
        //其他位置
      var currentPosition = scene.editorOverlay.snapToGrid(x, y)

      // 位置不在网格中就会发生改变
      if(lastPosition !== currentPosition) {

        // 添加新的可撤销信息
        var undoObjectProperties = {"target": entityBase, "action": "move",
          "otherPosition": lastPosition, "currentPosition": currentPosition}
        var undoObject = scene.editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
        scene.editorOverlay.undoHandler.push([undoObject])

        // 更新到网格的位置
        lastPosition = currentPosition

        musicManager.playSound("createOrDropEntity")
      }
    }
    //位置改变的信号
    onXChanged: positionChanged()
    onYChanged: positionChanged()

    // 实体从实体池创建？？？
    onUsedFromPool: {
      lastPosition = Qt.point(x, y)
    }
    //entityBase的state和container各是什么

    // 检查实体是否被拖出边界 边界控制
    function positionChanged() {
      // 如果实例被拖拽 则检测
      if(entityBase.entityState == "entityDragged") {
        //调整个实例x的数 容器x的位置
        var xScreen = entityBase.x * scene.container.scale + scene.container.x

        //减去边栏的长度 差错检测
        var leftLimit = scene.editorOverlay.sidebar.width - 8 * scene.container.scale

        // 根据实体位置进行缩放  添加到容器的位置
        var yScreen = entityBase.y * scene.container.scale + scene.container.y

        // 最低点的检测 游戏窗口的公差值
        var bottomLimit = scene.gameWindowAnchorItem.height - 17 * scene.container.scale

        // 检测实体是否超过限制范围 看是否创建实体
        if(xScreen < leftLimit || yScreen > bottomLimit)
          forbidBuild = true
        else
          forbidBuild = false
      }
    }
  }
