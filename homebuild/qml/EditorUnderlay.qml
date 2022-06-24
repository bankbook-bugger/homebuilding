import Felgo 3.0
<<<<<<< HEAD
import QtQuick 2.15

PinchArea {
  id: pinchArea

  property var scene: parent

  property var editorOverlay: scene.editorOverlay

  enabled: false

=======
import QtQuick 2.0

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
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
  anchors.fill: parent.gameWindowAnchorItem

  onPinchStarted: console.debug("pinch started")

  onPinchUpdated: {
<<<<<<< HEAD
    var zoomFactor = pinch.scale / pinch.previousScale

=======
    // calculate actual zoom factor
    var zoomFactor = pinch.scale / pinch.previousScale

    // apply zoom
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
    scene.camera.applyZoom(zoomFactor, pinch.startCenter)
  }

  onPinchFinished: console.debug("pinch finished")

<<<<<<< HEAD
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
=======
  // mouse area for object placement and camera movement
  // Note: We have to put the MouseArea inside the PinchArea for both areas to work.
  // This is a known issue: https://bugreports.qt.io/browse/QTBUG-35273
  MouseArea {
    id: baseEditMouseArea

    anchors.fill: parent

    // enabled, if pinch area is enabled
    enabled: pinchArea.enabled

    // The time since the last try to place an entity. We
    // use this to add some time between placing entities
    // in draw mode. This improves the performance, since
    // we don't need to check if the entity can be built
    // in every frame.
    property var lastCreateTime: 0

    // store previous mouse location to calculate drag movement for camera
    property point prevMouseLocation: Qt.point(0, 0)

    // to check how much the camera was moved in a whole drag
    property point dragStartPosition

    // here we store the distance of the last mouse drag
    property real dragDistance: 0

    // When draw-creating, or -removing entities, we want to be able to undo/redo
    // the whole draw stroke at once. This list temporarily holds all created/removed
    // entities, while the drawing is in progress. onRelease this list is pushed to
    // the undoHandler and reset.
    property var undoObjectsSubList: []

    onClicked: {
      // if in draw mode,
      // OR if in hand mode AND the mouse moved just a little bit...
      // (We add this dragDistance check, because we also want to place an entity
      // if the user clicks to place, but the mouse/finger moves a little bit
      // during the click)
      if(editorOverlay.sidebar.activeTool === "draw" || (editorOverlay.sidebar.activeTool === "hand" && dragDistance < 4)) {
        // ...place entity
        var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

        // if entity was successfully created
        if(entity) {
          // add undoObject to undoHandler
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
          var undoObjectProperties = {"target": entity, "action": "create",
            "currentPosition": Qt.point(entity.x, entity.y)}
          var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
          editorOverlay.undoHandler.push([undoObject])
        }
      }
    }

<<<<<<< HEAD
    onLongPressed: {
     //当你长按左侧实体时，
=======
    onPressed: {
      // if draw editorOverlay.sidebar.activeTool is active, set editorOverlay.selectedButton property to currently
      // selected BuildEntityButton
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
      if(editorOverlay.sidebar.activeTool === "draw") {
        for(var i=0; i<editorOverlay.sidebar.buttons.length; i++) {
          if(editorOverlay.sidebar.buttons[i].isSelected) {
            editorOverlay.selectedButton = editorOverlay.sidebar.buttons[i]
          }
        }
      }

      if(editorOverlay.sidebar.activeTool === "hand") {
<<<<<<< HEAD
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY

=======
        // save current mouse location
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY

        // save drag start position
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
        dragStartPosition = Qt.point(mouseX, mouseY)
      }
    }

<<<<<<< HEAD
    onPointChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime() // get current time

        if(currentTime - lastCreateTime > 5) {
          var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

          if(entity) {
=======
    // this is called every time the mouse is moved while it's pressed
    onPositionChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime() // get current time

        // Calculate time since last try to create an entity.
        // If it's over a threshold, try to place another entity.
        // This improves the performance, as we don't have to
        // check for collisions on every position change.
        if(currentTime - lastCreateTime > 5) {
          // place entity
          var entity = editorOverlay.placeEntityAtPosition(mouseX, mouseY)

          // if entity was successfully created
          if(entity) {
            // add undoObject of entity to temporary undoObjectsSubList
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
            var undoObjectProperties = {"target": entity, "action": "create",
              "currentPosition": Qt.point(entity.x, entity.y)}
            var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)

            undoObjectsSubList.push(undoObject)

<<<<<<< HEAD
=======
            // save new lastCreateTime
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
            lastCreateTime = new Date().getTime()
          }
        }
      }
      else if(editorOverlay.sidebar.activeTool === "erase") {
<<<<<<< HEAD
        var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(mouseX, mouseY)
        var body = physicsWorld.bodyAt(mousePosInLevel)

        if(body) {
          var target = body.target

          var undoObject = editorOverlay.removeEntity(target)

=======
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
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
          undoObjectsSubList.push(undoObject)
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand"){
<<<<<<< HEAD
        var deltaX = prevMouseLocation.x - mouseX
        var deltaY = prevMouseLocation.y - mouseY

        scene.camera.moveFreeCamera(deltaX, deltaY)

=======
        // move camera
        // calculate mouse movement since last frame
        var deltaX = prevMouseLocation.x - mouseX
        var deltaY = prevMouseLocation.y - mouseY

        // update camera position
        scene.camera.moveFreeCamera(deltaX, deltaY)

        // save current mouse location as previous mouse location
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
        prevMouseLocation.x = mouseX
        prevMouseLocation.y = mouseY
      }
    }

<<<<<<< HEAD
    onCanceled: {
      if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
        if(undoObjectsSubList.length > 0) {
          editorOverlay.undoHandler.push(undoObjectsSubList)

=======
    onReleased: {
      if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
        if(undoObjectsSubList.length > 0) {
          // push undoObjectsSubList to undoHandler
          editorOverlay.undoHandler.push(undoObjectsSubList)

          // reset undoObjectsSubList
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
          undoObjectsSubList = []
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand") {
<<<<<<< HEAD
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
=======
        // calculate moving distance since pressed event
        var deltaX = dragStartPosition.x - mouseX
        var deltaY = dragStartPosition.y - mouseY

        // calculate the total distance of the drag
        dragDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

        // apply the current movement velocity to the camera
        scene.camera.applyVelocity()
      }
    } // onReleased end

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
  } // MouseArea end
>>>>>>> 20b4227980cf895e1a21556f4e97a21473cf9bd7
}
