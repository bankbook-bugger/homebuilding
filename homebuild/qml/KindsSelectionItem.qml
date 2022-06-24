
import QtQuick 2.15
import Felgo 3.0
Item {
    id: kindsSelectionItem

    width: 50
    height: 50
    //如果是在选择关卡就加载这个
    Rectangle{
        id:demoChoice
        width: parent.width
        height: parent.height
        radius: 50
        color: hovered?"c0c0c0":"#413d3c"
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
