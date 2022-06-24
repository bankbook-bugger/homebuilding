import QtQuick 2.15
import Felgo 3.0

//侧边栏按钮

BuildEntityButton{
    //实体显示的大小默认是32*32(要收集的材料定义为64*64)
    property int buttonSize:32
    property bool isSelected:false

    width:buttonSize
    height: buttonSize
    //上一级组件的horizontalCenter是？？？
    anchors.horizontalCenter: parent.horizontalCenter
    //初始位置在关卡外（好像没用
    initialEntityPosition: Qt.point(-100,0)
    //变体类型（变体类型对于共享相同属性和逻辑（因此基本上是相同的实体类型）但这些属性的初始设置不同的实体很有用。）

    //createEntity是哪里的
    variationType: createdEntity ? createdEntity.variationType : ""

    //signals
    signal selected
    signal unselected
    //如果这个组件被选中，就强调他（变大加白
    Rectangle{
        id:selectedRectangle
        visible: isSelected
        //强调
        width:parent.width+8
        height: parent.height+8
        anchors.centerIn: parent
        radius: 3
        color: "white"
    }
    //给背景为空的png图片添加一个背景再显示
    Rectangle {
      id: background
      anchors.fill: buttonImage
      radius: 3
      color: "#a0b0b0b0"
    }
    MultiResolutionImage{
        id:buttonImage
        //createdEntity是什么
        source: createdEntity?createdEntity.image.source:""
        //当选中的时候变大
        width: isSelected?36:32
        height: isSelected?36:32
        anchors.centerIn: parent
    }
    onClicked: {
        isSelected=!isSelected
        if(isSelected)
            selected()
        else
            unselected()
    }
    onEntityWasBuilt: {
        //builtEntityId是信号中传来的参数
        var builtEntity=entityManager.getEntityById(builtEntityId)
        if(builtEntity) {
          //撤销的键可以使用了
          var undoObjectProperties = {"target": builtEntity, "action": "create",
            "currentPosition": Qt.point(builtEntity.x, builtEntity.y)}
          var undoObject = editorOverlay.undoHandler.createUndoObject(undoObjectProperties)
          editorOverlay.undoHandler.push([undoObject])
        }
    }


}

