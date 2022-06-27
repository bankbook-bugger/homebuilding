import QtQuick 2.0
import Felgo 3.0

Item {
  id: undoObject

  property var target
  property var targetEntityType
  property var targetVariationType

  //执行的操作 "create", "remove" or "move"
  property string action

  //组件最近的位置
  property point currentPosition
  //对象的其他位置（仅用于“移动”）
  property point otherPosition

  //当我们设置了target后，保存他的entityType和variationType
  onTargetChanged: {
    if(target !== null) {
      targetEntityType = target.entityType
      targetVariationType = target.variationType
    }
  }

  function undo() {
    if(action == "create") {
      //如果前一个操作是创建，那撤销就是删除这个组件
      removeTargetObject()
    }
    else if(action == "remove") {
      //如果前一个操作是删除，那撤销就是重新创建那个组件
      createTargetObject()
    }
    else if(action == "move") {
      //如果前一个操作是移动，那撤销就是返回移动之前的位置
      moveTargetObject()
    }
  }
  //action在undo操作后不会变吗？？
  function redo() {
    if(action == "create") {
      //重新创建最近删除的
      createTargetObject()
    }
    else if(action == "remove") {
      console.debug("redo remove "+target+", at "+currentPosition)

      // 重新删除？？
      removeTargetObject()
    }
    else if(action == "move") {
      console.debug("redo move "+target+", from "+otherPosition
                    +" to "+currentPosition)

      //还原移动
      moveTargetObject()
    }
    else {
      console.debug("unknown action: "+action)
    }
  }

  function createTargetObject() {
    // set properties
    var properties = {
      entityType: targetEntityType,
      variationType: targetVariationType,
      x: currentPosition.x,
      y: currentPosition.y
    }
    // 根据properties创建并且储存id
    var newEntityId = entityManager.createEntityFromEntityTypeAndVariationType(properties)

    // 设置target
    target = entityManager.getEntityById(newEntityId)
  }

  function removeTargetObject() {
      //获取当前位置网格中的对象，并将其作为新目标
      var bodyAtPos = Qt.point(currentPosition.x + 16, currentPosition.y + 16)
      target = gameScene.physicsWorld.bodyAt(bodyAtPos).target

      //如果当前target存在，就删除他
      if(target) {
        entityManager.removeEntityById(target.entityId)
      }
  }

  //将目标从当前位置移动到其他位置
  function moveTargetObject() {
    //在最近的位置寻找组件并获取
    var bodyAtPos = Qt.point(currentPosition.x + 16, currentPosition.y + 16)
    target = gameScene.physicsWorld.bodyAt(bodyAtPos).target
    //用之前的位置替换现在的位置
    if(target) {
      target.x = otherPosition.x
      target.y = otherPosition.y

      // 设置lastPosition
      target.lastPosition = Qt.point(target.x, target.y)

      var helper = Qt.point(currentPosition.x, currentPosition.y)
      currentPosition = otherPosition
      otherPosition = helper
    }
  }

}
