import QtQuick 2.0
import Felgo 3.0


HomeEntityBaseDraggable {
  id: coin
  entityType: "coin"

  property bool collected: false


  image.visible: !collected

  colliderComponent: collider

  // set image
  image.source: "../assets/coin/coin.png"

  CircleCollider {
    id: collider

    radius: parent.width / 2 - 3

    // center collider
    x: 3
    y: 3

    active: !collected

    bodyType: Body.Static
    collisionTestingOnlyMode: true


    categories: Box.Category6

    collidesWith: Box.Category1
  }


  function collect() {
    console.debug("collect coin")
    coin.collected = true

    gameScene.time -= 5

    audioManager.playSound("collectCoin")
  }


  function reset() {
    coin.collected = false
  }
}
