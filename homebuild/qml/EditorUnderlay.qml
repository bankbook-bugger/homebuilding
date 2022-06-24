import Felgo 3.0
import QtQuick 2.15

// the PinchArea enables pinch-zooming (2-finger-zoom)
PinchArea {
  id: pinchArea

  // this is the gameScene, under which this underlay is put
  property var scene: parent

  // makes accessing editorOverlay easier
  property var editorOverlay: scene.editorOverlay

  // disabled by default
  enabled: false

  // the pinch and mouse area should fill the game window, not just the scene
  anchors.fill: parent.gameWindowAnchorItem

  onPinchStarted: console.debug("pinch started")

  onPinchUpdated: {
    // calculate actual zoom factor
    var zoomFactor = pinch.scale / pinch.previousScale

    // apply zoom
    scene.camera.applyZoom(zoomFactor, pinch.startCenter)
  }

  onPinchFinished: console.debug("pinch finished")

  // mouse area for object placement and camera movement
  // Note: We have to put the MouseArea inside the PinchArea for both areas to work.
  // This is a known issue: https://bugreports.qt.io/browse/QTBUG-35273
  TapHandler {
    id: baseEditMouseArea


    // enabled, if pinch area is enabled
    enabled: pinchArea.enabled


    property var lastCreateTime: 0

    // store previous mouse location to calculate drag movement for camera
    property point prevMouseLocation: Qt.point(0, 0)

    // to check how much the camera was moved in a whole drag
    property point dragStartPosition

    // here we store the distance of the last mouse drag
    property real dragDistance: 0


    property var undoObjectsSubList: []

    onTapped: {

      if(editorOverlay.sidebar.activeTool === "draw" || (editorOverlay.sidebar.activeTool === "hand" && dragDistance < 4)) {
        // ...place entity
        var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

        // if entity was successfully created
        if(entity) {
          // add undoObject to undoHandler
          var undoObjectProperties = {"target": entity, "action": "create",
            "currentPosition": Qt.point(entity.x, entity.y)}
          var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
          editorOverlay.undoHandler.push([undoObject])
        }
      }
    }

    onLongPressed: {
      // if draw editorOverlay.sidebar.activeTool is active, set editorOverlay.selectedButton property to currently
      // selected BuildEntityButton
      if(editorOverlay.sidebar.activeTool === "draw") {
        for(var i=0; i<editorOverlay.sidebar.buttons.length; i++) {
          if(editorOverlay.sidebar.buttons[i].isSelected) {
            editorOverlay.selectedButton = editorOverlay.sidebar.buttons[i]
          }
        }
      }

      if(editorOverlay.sidebar.activeTool === "hand") {
        // save current mouse location
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY

        // save drag start position
        dragStartPosition = Qt.point(mouseX, mouseY)
      }
    }

    // this is called every time the mouse is moved while it's pressed
    onPointChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime() // get current time

        if(currentTime - lastCreateTime > 5) {
          // place entity
          var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

          // if entity was successfully created
          if(entity) {
            // add undoObject of entity to temporary undoObjectsSubList
            var undoObjectProperties = {"target": entity, "action": "create",
              "currentPosition": Qt.point(entity.x, entity.y)}
            var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)

            undoObjectsSubList.push(undoObject)

            // save new lastCreateTime
            lastCreateTime = new Date().getTime()
          }
        }
      }
      else if(editorOverlay.sidebar.activeTool === "erase") {
        // convert mouse to level coordinates
        var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(mouseX, mouseY)
        // get body at mouse position
        var body = physicsWorld.bodyAt(mousePosInLevel)

        // if body exists, remove entity
        if(body) {
          // get target object
          var target = body.target

          // remove entitiy
          var undoObject = editorOverlay.removeEntity(target)

          // add undoObject to temporary undoObjectsSubList
          undoObjectsSubList.push(undoObject)
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand"){
        // move camera
        // calculate mouse movement since last frame
        var deltaX = prevMouseLocation.x - mouseX
        var deltaY = prevMouseLocation.y - mouseY

        // update camera position
        scene.camera.moveFreeCamera(deltaX, deltaY)

        // save current mouse location as previous mouse location
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY
      }
    }

    onCanceled: {
      if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
        if(undoObjectsSubList.length > 0) {
          // push undoObjectsSubList to undoHandler
          editorOverlay.undoHandler.push(undoObjectsSubList)

          // reset undoObjectsSubList
          undoObjectsSubList = []
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand") {
        // calculate moving distance since pressed event
        var deltaX = dragStartPosition.x - mouseX
        var deltaY = dragStartPosition.y - mouseY

        // calculate the total distance of the drag
        dragDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

        // apply the current movement velocity to the camera
        scene.camera.applyVelocity()
      }
    } // onReleased end


  }
  MouseArea{
  anchors.fill: parent
  onWheel: {
    // get mouse position
    var mousePos = Qt.point(wheel.x, wheel.y)

    // determine if the mouse wheel is rotated upwards or downwards
    // zoom in or out, depending on the rotation direction
    if(wheel.angleDelta.y > 0)
      scene.camera.applyZoom(1.05, mousePos)
    else
      scene.camera.applyZoom(1 / 1.05, mousePos)

    console.debug("zoom via mouseWheel")
  }
  }
}
