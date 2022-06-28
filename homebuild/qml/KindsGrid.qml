import QtQuick 2.0
import Felgo 3.0

Item {
    id: kindsGrid

    anchors.top: kindsScene.state==="demoKinds"?mainBar.bottom:subBar.bottom
    anchors.bottom: kindsScene.gameWindowAnchorItem.bottom
    anchors.left: kindsScene.left
    anchors.right: kindsScene.right

    anchors.margins: 5
    anchors.topMargin: 0
    anchors.bottomMargin: 0
    //显示的关卡
    property var levelMetaDataArray
    //是否正在加载
    property bool isLoading:false

    onLevelMetaDataArrayChanged: {
        //如果加载完了，就把显示的model设置成关卡原部件
        if(!isLoading)
            kindsListRepeater.model=levelMetaDataArray
    }

    Flickable{
        id:kindsGridFlickable
        anchors.fill: parent
        clip: true
        contentWidth: grid.width
        contentHeight: grid.height
        //允许竖直方向滑动
        flickableDirection: Flickable.VerticalFlick
        Grid{
            id:grid
            columns: 4
            spacing: 10
            //加载关卡
            Repeater{
                id:kindsListRepeater
                delegate: KindsSelectionItem{}
            }
        }
    }
    Timer{
        id:loadingTimer
        interval: 1000
        onTriggered: finishLoading()
    }
    function startLoading(){
        kindsListRepeater.model=null
        isLoading=true
        loadingTimer.start()
    }
    function finishLoading(){
        isLoading=false
        kindsListRepeater.model=levelMetaDataArray
    }


}
