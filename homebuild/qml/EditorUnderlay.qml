import Felgo 3.0
import QtQuick 2.15

PinchArea {
  id: pinchArea

  property var scene: parent

  property var editorOverlay: scene.editorOverlay

  enabled: false

  anchors.fill: parent.gameWindowAnchorItem

  onPinchStarted: console.debug("pinch started")

  onPinchUpdated: {
    var zoomFactor = pinch.scale / pinch.previousScale

    scene.camera.applyZoom(zoomFactor, pinch.startCenter)
  }

  onPinchFinished: console.debug("pinch finished")

  TapHandler {
    id: baseEditMouseArea

    enabled: pinchArea.enabled

    property var lastCreateTime: 0

    property point prevMouseLocation: Qt.point(0, 0)

    property point dragStartPosition

    property real dragDistance: 0

    property var undoObjectsSubList: []

    onTapped: {
        //单击左侧的实体，鼠标的坐标就是实体创建的位置

      if(editorOverlay.sidebar.activeTool === "draw" || (editorOverlay.sidebar.activeTool === "hand" && dragDistance < 4)) {
        var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

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
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY

        dragStartPosition = Qt.point(mouseX, mouseY)
      }
    }

    onPointChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime()

        if(currentTime - lastCreateTime > 5) {
          var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

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
        var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(mouseX, mouseY)
        var body = physicsWorld.bodyAt(mousePosInLevel)

        if(body) {
          var target = body.target

          var undoObject = editorOverlay.removeEntity(target)

          undoObjectsSubList.push(undoObject)
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand"){

        var deltaX = prevMouseLocation.x - mouseX
        var deltaY = prevMouseLocation.y - mouseY

        scene.camera.moveFreeCamera(deltaX, deltaY)

        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY
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
        var deltaX = dragStartPosition.x - mouseX
        var deltaY = dragStartPosition.y - mouseY

        dragDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

        scene.camera.applyVelocity()
      }
    }


  }
  MouseArea{
      //获取滑轮事件，随之将游戏场景进行放大缩小
      anchors.fill: parent
      onWheel: {
        var mousePos = Qt.point(wheel.x, wheel.y)

        if(wheel.angleDelta.y > 0)
          scene.camera.applyZoom(1.05, mousePos)
        else
          scene.camera.applyZoom(1 / 1.05, mousePos)

        console.debug("zoom via mouseWheel")
      }}
}
