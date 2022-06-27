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


  TapHandler {               //用于放在地图里的方块区域
    id: baseEditTap
    enabled: pinchArea.enabled

    property var lastCreateTime: 0  //添加时间 在每个所创建的实体之间

    // 存储上一个实体的位置 为了进行下一个位置的拖动
    property point prevMouseLocation: Qt.point(0, 0)

    //检查拖动过程中的拖动量
    property point dragStartPosition

    //存储最后一次鼠标拖动的距离
    property real dragDistance: 0

    //创建或删除实体时，用一个列表去存储所创建或删除的实体
    property var undoObjectsSubList: []

    onTapped: {
      // 在绘图模式中 鼠标拖动可以一直使用当前图片放置
      if(editorOverlay.sidebar.activeTool === "draw" || (editorOverlay.sidebar.activeTool === "hand" && dragDistance < 4)) {
        var entity = editorOverlay.placeEntityAtPosition(point.X, point.Y)

        if(entity) {//如果创建成功 添加此实体
          var undoObjectProperties = {"target": entity, "action": "create",
            "currentPosition": Qt.point(entity.x, entity.y)}

          var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
          editorOverlay.undoHandler.push([undoObject])
        }
      }

    }

    onLongPressed: {//如果当前编辑器处于活动状态 则设置侧边栏被选择button的数组
        //为了撤回功能准备
      if(editorOverlay.sidebar.activeTool === "draw") {
        for(var i=0; i<editorOverlay.sidebar.buttons.length; i++) {
          if(editorOverlay.sidebar.buttons[i].isSelected) {
            editorOverlay.selectedButton = editorOverlay.sidebar.buttons[i]
          }
        }
      }

      //如果当前为移动（手）的模式 则保存最后移动或则拖拽的位置
      if(editorOverlay.sidebar.activeTool === "hand") {
        prevMouseLocation.x = point.X
        prevMouseLocation.y = point.Y
        dragStartPosition = Qt.point(point.X, point.Y)
      }
    }

    //按下鼠标时 切换为编辑模式
    onPointChanged: {
      if(editorOverlay.sidebar.activeTool === "draw") {
        var currentTime = new Date().getTime() // get current time


          //检查上次创建实体以来的属性 查看是否超过所定的值
        if(currentTime - lastCreateTime > 5) {
          var entity = editorOverlay.placeEntityAtPosition(point.X, point.Y)

          //如果实体成功创建，则将此实体放在地图列表里
          if(entity) {
            var undoObjectProperties = {"target": entity, "action": "create",
              "currentPosition": Qt.point(entity.x, entity.y)}
            var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)

            undoObjectsSubList.push(undoObject)

            // 保存最后一个创建的时间
            lastCreateTime = new Date().getTime()
          }
        }
      }
      else if(editorOverlay.sidebar.activeTool === "erase") {
        var mousePosInLevel = editorOverlay.mouseToLevelCoordinates(point.X, point.Y)
          //将鼠标位置转化为坐标
        var body = physicsWorld.bodyAt(mousePosInLevel)

        if(body) {  //如果body被撤销，添加到临时的数组里
          var target = body.target
          var undoObject = editorOverlay.removeEntity(target)
          undoObjectsSubList.push(undoObject)
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand"){
        var deltaX = prevMouseLocation.x - point.X
        var deltaY = prevMouseLocation.y - point.Y
        scene.camera.moveFreeCamera(deltaX, deltaY)

        // 保存当前鼠标的位置
        prevMouseLocation.x = point.X
        prevMouseLocation.y = point.Y
      }

    }


    onCanceled: {
      if(editorOverlay.sidebar.activeTool === "draw" || editorOverlay.sidebar.activeTool === "erase") {
        if(undoObjectsSubList.length > 0) {
          // 将撤回或则添加的实体放在 实体列表里
          editorOverlay.undoHandler.push(undoObjectsSubList)

          // 重置实体列表
          undoObjectsSubList = []
        }
      }
      else if(editorOverlay.sidebar.activeTool === "hand") {
        // 计算鼠标按下后移动的距离
        var deltaX = dragStartPosition.x - point.X
        var deltaY = dragStartPosition.y - point.Y

        // 计算鼠标拖动的距离
        dragDistance = Math.sqrt(deltaX * deltaX + deltaY * deltaY)

        // 在相机位置 移动相应的距离
        scene.camera.applyVelocity()
      }
    }


  }

  WheelHandler{    //使用滚轮类型的Handler 进行缩放
      onWheel: {
        var mousePos = Qt.point(event.x, event.y) //得到当前鼠标点的位置

        //确认鼠标向上还是向下 所对应的旋转方向
        if(event.angleDelta.y > 0)
          scene.camera.applyZoom(1.05, mousePos)
        else
          scene.camera.applyZoom(1 / 1.05, mousePos)

        console.debug("zoom via mouseWheel")
      }
  }


}
