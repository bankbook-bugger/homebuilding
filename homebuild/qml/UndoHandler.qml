import QtQuick 2.0
import Felgo 3.0

Item {
  id: undoHandler

  //存储所有撤销的组件
  property var undoArray: []

  //存储在undoArray中的位置
  property int pointer: -1

  onPointerChanged: console.debug("undo pointer: "+pointer)

  function createUndoObject(properties) {
    var component = Qt.createComponent("UndoObject.qml")

    //使用properties在游戏场景中创建对象
    var undoObject = component.createObject(gameScene, properties)

    return undoObject
  }


  function push(undoObjectList) {
      console.log("\n")
      console.log(undoObjectList)
      console.log("\n")
      //在添加新undoObject之前，所有之前撤销的操作都已经删除
    if(undoArray.length > pointer + 1)
      undoArray.splice(pointer+1, undoArray.length)

    undoArray.push(undoObjectList)

    //更新 pointer
    pointer++
  }

  function undo() {
    if(undoArray[pointer]) {

      for(var i=0; i<undoArray[pointer].length; i++) {
        undoArray[pointer][i].undo()
      }

      pointer--
    }
    else {
      console.debug("nothing to undo")
    }
  }

  function redo() {
    if(undoArray[pointer+1]) {

      for(var i=0; i<undoArray[pointer+1].length; i++) {
        undoArray[pointer+1][i].redo()
      }
      pointer++
    }
    else {
      console.debug("nothing to redo")
    }
  }

  //打印撤销队列中的所有组件
  function printArray() {
    console.debug("print undoArray")
    for(var i=0; i< undoArray.length; i++) {
      for(var j=0; j<undoArray[i].length; j++) {
        console.debug(i+"-"+j+": "+undoArray[i][j].target+", "+undoArray[i][j].action+", "+undoArray[i][j].otherPosition+", "+undoArray[i][j].currentPosition)
      }
    }
  }

  //重置
  function reset() {
    undoArray = []
    pointer = -1
  }

}
