import QtQuick 2.0
import Felgo 3.0


HomeEntityBaseDraggable {
  id: coin
  entityType: "coin"

  // this property is true when the player collected the coin
  property bool collected: false

  // when the coin is collected, it shouldn't be visible anymore
  image.visible: !collected

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  // set image
  image.source: "../../assets/coin/coin.png"

  CircleCollider {
    id: collider

    // make the collider a little smaller than the sprite
    radius: parent.width / 2 - 3

    // center collider
    x: 3
    y: 3

    // disable collider when coin is collected
    active: !collected

    // the collider is static (shouldn't move) and should only test
    // for collisions
    bodyType: Body.Static
    collisionTestingOnlyMode: true

    // Category6: powerup
    categories: Box.Category6
    // Category1: player body
    collidesWith: Box.Category1
  }

  // set collected to true
  function collect() {
    console.debug("collect coin")
    coin.collected = true

    // for every collected coin, the time gets set back a little bit
    gameScene.time -= 5

    audioManager.playSound("collectCoin")
  }

  // reset coin
  function reset() {
    coin.collected = false
  }
}
