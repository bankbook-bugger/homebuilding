import QtQuick 2.15
import QtQuick.Controls.Styles 1.0
import Felgo 3.0
AppButton{
    id: kindsSelectionItem
    style: ButtonStyle {         //覆盖默认felgo的样式
      background: Rectangle {
          color: "transparent"
      }
    }
    width: 60
    height: 60
    //如果是在选择关卡就加载这个
    Rectangle{
        id:demoChoice
        width: parent.width
        height: parent.height
        radius: 50
        color: hovered? "#413d3c": "#c0c0c0"
        Text {
            id:number
            text: modelData.levelName
            anchors.centerIn: parent
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            fontSizeMode: Text.Fit
            font.pixelSize: 13
            minimumPixelSize: 8
        }
        TapHandler{
            onTapped:{
                kindsScene.playLevelPressed(modelData)
                musicManager.playSound("start")}
        }
    }

}
