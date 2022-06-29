/*2022.6.27
  wanglingzhi*/

import Felgo 3.0
import QtQuick 2.15
import QtQuick.Controls 2.1

//qml使用PinchArea启动  触摸屏时双手指触摸
PinchArea {
    id: pinchArea

    property var scene: parent  //此界面在游戏场景里

    property var editorOverlay: scene.editorOverlay  //访问Overlay里的属性

    enabled: false  //默认不可见
    anchors.fill: parent.gameWindowAnchorItem

    onPinchStarted: console.debug("开始缩放")

    onPinchUpdated: {

        var zoomFactor = pinch.scale / pinch.previousScale //缩放大小
        scene.camera.applyZoom(zoomFactor, pinch.startCenter)
    }

    onPinchFinished: console.debug("缩放结束")

    MouseArea {
        id: baseEditMouseArea

        anchors.fill: parent
        enabled: pinchArea.enabled
        property var lastCreateTime: 0
        property point prevMouseLocation: Qt.point(0, 0)
        property point dragStartPosition

        property real dragDistance: 0
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
                    var undoObjectProperties = {"target": entity, "action": "create",
                        "currentPosition": Qt.point(entity.x, entity.y)}
                    var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
                    editorOverlay.undoHandler.push([undoObject])
                }
            }
        }

        onPressed: {
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

        onReleased: {
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
        onWheel: {
            var mousePos = Qt.point(mouseX, mouseY) //得到当前鼠标点的位置

            //确认鼠标向上还是向下 所对应的旋转方向
            if(wheel.angleDelta.y > 0)
                scene.camera.applyZoom(1.05, mousePos)
            else
                scene.camera.applyZoom(1 / 1.05, mousePos)

            console.debug("zoom via mouseWheel")
        }

    } // MouseArea end
    //    TapHandler {               //用于放在地图里的方块区域
    //        id: baseEditTap
    //        enabled: pinchArea.enabled
    //        dragThreshold:1000
    //        property var lastCreateTime: 0  //添加时间 在每个所创建的实体之间

    //        // 存储上一个实体的位置 为了进行下一个位置的拖动
    //        property point prevMouseLocation: Qt.point(0, 0)

    //        //检查拖动过程中的拖动量
    //        property point dragStartPosition

    //        //存储最后一次鼠标拖动的距离
    //        property real dragDistance: 0

    //        //创建或删除实体时，用一个列表去存储所创建或删除的实体
    //        property var undoObjectsSubList: []
    //        //=按下松开
    //        onTapped: {
    //            // 在绘图模式中 鼠标拖动可以一直使用当前图片放置
    //            if(editorOverlay.sidebar.activeTool === "draw") {
    //                //获取实体
    //                var entity = editorOverlay.placeEntityAtPosition(eventPoint.position.x, eventPoint.position.y)

    //                if(entity) {//如果创建成功 添加此实体
    //                    var undoObjectProperties = {"target": entity, "action": "create",
    //                        "currentPosition": Qt.point(entity.x, entity.y)}
    //                    var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
    //                    editorOverlay.undoHandler.push([undoObject])
    //                }
    //            }


    //            //如果当前编辑器处于活动状态 则设置侧边栏被选择button的数组
    //            //为了撤回功能准备
    //            if(editorOverlay.sidebar.activeTool === "draw") {
    //                for(var i=0; i<editorOverlay.sidebar.buttons.length; i++) {
    //                    if(editorOverlay.sidebar.buttons[i].isSelected) {
    //                        editorOverlay.selectedButton = editorOverlay.sidebar.buttons[i]
    //                    }
    //                }
    //            }

    //            //如果当前为移动（手）的模式 则保存最后移动或则拖拽的位置
    //            if(editorOverlay.sidebar.activeTool === "hand") {
    //                prevMouseLocation.x = eventPoint.position.x
    //                prevMouseLocation.y = eventPoint.position.y
    //            }
    //            if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
    //                if(undoObjectsSubList.length > 0) {
    //                    // 将撤回或则添加的实体放在 实体列表里
    //                    editorOverlay.undoHandler.push(undoObjectsSubList)

    //                    // 重置实体列表

    //                    undoObjectsSubList = []
    //                }
    //            }
    //        }

    //        //根据鼠标拖拽的位置不断进行变化
    //        onPointChanged: {
    //            if(editorOverlay.sidebar.activeTool === "draw") {
    //                var currentTime = new Date().getTime() // get current time


    //                //检查上次创建实体以来的属性 查看是否超过所定的值
    //                if(currentTime - lastCreateTime > 5) {
    //                    var entity = editorOverlay.placeEntityAtPosition(point.position.x, point.position.y)

    //                    //如果实体成功创建，则将此实体放在地图列表里
    //                    if(entity) {
    //                        var undoObjectProperties = {"target": entity, "action": "create",
    //                            "currentPosition": Qt.point(entity.x, entity.y)}
    //                        var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)

    //                        undoObjectsSubList.push(undoObject)
    //                        // 保存最后一个创建的时间
    //                        lastCreateTime = new Date().getTime()
    //                    }
    //                }
    //            }
    //            else if(editorOverlay.sidebar.activeTool === "erase") {
    //                var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(point.position.x, point.position.y)
    //                //将鼠标位置转化为坐标
    //                var body = physicsWorld.bodyAt(mousePosInLevel)

    //                if(body) {  //如果body被撤销，添加到临时的数组里
    //                    var target = body.target
    //                    var undoObject = editorOverlay.removeEntity(target)
    //                    undoObjectsSubList.push(undoObject)
    //                }
    //            }
    //            else if(editorOverlay.sidebar.activeTool === "hand"){
    //                //hand拖拽更新位置
    //                var deltaX = prevMouseLocation.x - point.position.x
    //                var deltaY = prevMouseLocation.y - point.position.y
    //                scene.camera.moveFreeCamera(deltaX, deltaY)

    //                // 保存当前鼠标的位置
    //                prevMouseLocation.x = point.position.x
    //                prevMouseLocation.y = point.position.y
    //            }

    //        }
    //    }

    //    WheelHandler{    //使用滚轮类型的Handler 进行缩放
    //        onWheel: {
    //            var mousePos = Qt.point(event.x, event.y) //得到当前鼠标点的位置

    //            //确认鼠标向上还是向下 所对应的旋转方向
    //            if(event.angleDelta.y > 0)
    //                scene.camera.applyZoom(1.05, mousePos)
    //            else
    //                scene.camera.applyZoom(1 / 1.05, mousePos)

    //            console.debug("zoom via mouseWheel")
    //        }
    //    }


}
