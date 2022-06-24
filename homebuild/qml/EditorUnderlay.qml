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

 //对编辑页面进行的鼠标操作
  TapHandler {
    id: baseEditMouseArea

    enabled: pinchArea.enabled

    property var lastCreateTime: 0

    property point prevMouseLocation: Qt.point(0, 0)

    property point dragStartPosition

    property real dragDistance: 0


    property var undoObjectsSubList: []

    onTapped: {
     //当你单击左侧实体时，就检测你鼠标在下次点击的坐标在哪，该点就是创建实体的位置
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
     //当你长按左侧实体时，
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
        var currentTime = new Date().getTime() // get current time

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
  onWheel:{    //捕捉滑轮事件，游戏场景做出相应的放大缩小
              var mousePos = Qt.point(wheel.x, wheel.y)

              if(wheel.angleDelta.y > 0)
                scene.camera.applyZoom(1.05, mousePos)
              else
                scene.camera.applyZoom(1 / 1.05, mousePos)

              console.debug("zoom via mouseWheel")
            }
          }
}
