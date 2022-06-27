import Felgo 3.0
import QtQuick 2.15

PinchArea {
  id: pinchArea

  property var scene: parent

  property var editorOverlay: scene.editorOverlay

  //enabled: false

  anchors.fill: parent.gameWindowAnchorItem
  //pinch(捏和)开始的反应
  onPinchStarted: console.debug("pinch started")
  //更新过程
  onPinchUpdated: {
    var zoomFactor = pinch.scale / pinch.previousScale
    scene.camera.applyZoom(zoomFactor, pinch.startCenter)
  }

  onPinchFinished: console.debug("pinch finished")

  TapHandler {
    id: baseEditMouse
    enabled: pinchArea.enabled

    property var lastCreateTime: 0

    property point prevMouseLocation: Qt.point(0, 0)

    property point dragStartPosition

    property real dragDistance: 0

    property var undoObjectsSubList: []

    onTapped: {
        //单击左侧的实体，鼠标的坐标就是实体创建的位置

      if(editorOverlay.sidebar.activeTool === "draw" || (editorOverlay.sidebar.activeTool === "hand" && dragDistance < 4)) {
        var entity = editorOverlay.placeEntityAtPosition(point.x, point.y)

        if(entity) {
          var undoObjectProperties = {"target": entity, "action": "create",
            "currentPosition": Qt.point(entity.x, entity.y)}
          var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
          editorOverlay.undoHandler.push([undoObject])
        }
      }
    }

    onLongPressed: {

      if(editorOverlay.sidebar.activeTool === "draw") {
        for(var i=0; i<editorOverlay.sidebar.buttons.length; i++) {
          if(editorOverlay.sidebar.buttons[i].isSelected) {
            editorOverlay.selectedButton = editorOverlay.sidebar.buttons[i]
          }
        }
      }

      if(editorOverlay.sidebar.activeTool === "hand") {
          // 保存最近鼠标点击的位置
          prevMouseLocation.x = point.x
          prevMouseLocation.y = point.y

          // 保存拖拽的位置
          dragStartPosition = Qt.point(point.x, point.y)
      }
    }

    onPressedChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime()

        if(currentTime - lastCreateTime > 5) {
          var entity = editorOverlay.placeEntityAtPosition(point.x, point.y)

          if(entity) {
            var undoObjectProperties = {"target": entity, "action": "create",
              "currentPosition": Qt.point(entity.x, entity.y)}
            var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)

            undoObjectsSubList.push(undoObject)

            lastCreateTime = new Date().getTime()
          }
        }
      }
      else if(editorOverlay.sidebar.activeTool === "erase") {
        var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(point.x, point.y)
        var body = physicsWorld.bodyAt(mousePosInLevel)

        if(body) {
          var target = body.target

          var undoObject = editorOverlay.removeEntity(target)

          undoObjectsSubList.push(undoObject)
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand"){
        // move camera
        // calculate mouse movement since last frame
        var deltaX = prevMouseLocation.x - point.x
        var deltaY = prevMouseLocation.y - point.y

        // update camera position
        scene.camera.moveFreeCamera(deltaX, deltaY)

        // save current mouse location as previous mouse location
        prevMouseLocation.x = point.x
        prevMouseLocation.y = point.y
      }
    }

    onCanceled: {
      if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
        if(undoObjectsSubList.length > 0) {
          editorOverlay.undoHandler.push(undoObjectsSubList)

          undoObjectsSubList = []
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand") {
        var deltaX = dragStartPosition.x - point.x
        var deltaY = dragStartPosition.y - point.y

        dragDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

        scene.camera.applyVelocity()
      }
    }


  }
  WheelHandler{
      //获取滑轮事件，随之将游戏场景进行放大缩小
      onWheel: {
        var mousePos = Qt.point(point.x, point.y)

        if(point.angleDelta.y > 0)
          scene.camera.applyZoom(1.05, mousePos)
        else
          scene.camera.applyZoom(1 / 1.05, mousePos)

        console.debug("zoom via mouseWheel")
      }}
}
