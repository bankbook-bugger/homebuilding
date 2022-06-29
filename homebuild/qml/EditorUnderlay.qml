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
