import Felgo 3.0
import QtQuick 2.0
HomeEntityBaseDraggable {
  id: player
  entityType: "player"
  property int startX
  property int startY
  //两个方向上的速度
  property alias horizontalVelocity: collider.linearVelocity.x
  property alias verticalVelocity: collider.linearVelocity.y
  //收集到的金额
  property int score: 0
  //收集生命
  property int heart: 1
  // 不可以二连跳
  property bool doubleJumpEnabled: flase
  //如果玩家的脚下有地就不为0
  property int contacts: 0

  // these properties set the player's jump force for normal- and
  // kill-jumps
  property int normalJumpForce: 210
  property int killJumpForce: 420

  // This property holds how many more iterations the player's
  // jump height can increase. We use this to control the jump height.
  // See the ascentControl Timer for more details.
  property int jumpForceLeft: 20

  // the player's accelerationForce
  property int accelerationForce: 1000

  // the factor by how much the player's speed decreases when
  // the user stops pressing left or right
  property real decelerationFactor: 0.6

  // the player's maximum movement speed
  property int maxSpeed: 230

  // maximum falling speed
  property int maxFallingSpeed: 800

  /**
   * Signals ----------------------------------------------------
   */

  // signal for finishing the level
  signal finish

  /**
   * Object properties ----------------------------------------------------
   */

  // set the player's size to his image size
  width: image.width
  height: image.height

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  // set image
  image.source: "../assets/player/player.png"

  // make player smaller, if isBig is false
  scale: isBig ? 1 : 0.64
  // animate scale changes
  Behavior on scale { NumberAnimation { duration: 500 } }

  // transform from the center of the bottom
  transformOrigin: Item.Bottom

  // If the player touches another solid object, we set his state
  // to "walking". Otherwise we set it to "jumping".
  // The player can only jump when "walking", or by using the doubleJump.
  state: contacts > 0 ? "walking" : "jumping"

  // make player unremovable
  preventFromRemovalFromEntityManager: true

  // limit falling speed
  onVerticalVelocityChanged: {
    if(verticalVelocity > maxFallingSpeed)
      verticalVelocity = maxFallingSpeed
  }

  onFinish: audioManager.playSound("finish")

  /**
   * 碰撞检测部分---------------------------------------
   */

  //主要部分
  PolygonCollider {
    id: collider
    vertices:
    [
      Qt.point(21, 39),
      Qt.point(28, 34),
      Qt.point(39, 34),
      Qt.point(43, 39),
      Qt.point(43, 62.85),
      Qt.point(40, 63),
      Qt.point(23, 63),
      Qt.point(20, 62.85)
    ]
    bodyType: Body.Dynamic
    //在编辑就不生效
    active: !inLevelEditingMode
    // Category1: 玩家
    categories: Box.Category1
    // Category2: 怪物, Category4:地
    // Category3: 收集的素材, Category7: reset sensor（是啥）（和怪物的sensor同一类别
    collidesWith: Box.Category2 | Box.Category4 | Box.Category4| Box.Category7
    //不会处于休眠状态
    sleepingAllowed: false

    //controller是哪个？？
    force: Qt.point(controller.xAxis * accelerationForce, 0)

    // limit the horizontal velocity
    onLinearVelocityChanged: {
      if(linearVelocity.x > maxSpeed) linearVelocity.x = maxSpeed
      if(linearVelocity.x < -maxSpeed) linearVelocity.x = -maxSpeed
    }

    // this is called whenever the contact with another entity begins
    fixture.onBeginContact: {
      var otherEntity = other.getBody().target
        //如果在泥巴上就把摩擦力设为1，其他组件上没有摩擦
      if(otherEntity.entityType === "mud") {
          collider.friction=1
      }
      else
         collider.friction=0
      //如果是素材就收集，然后金币加10
      if(otherEntity.entityType === "material") {
        otherEntity.collect()
        score += 10
      }
      if(otherEntity.entityType === "heart") {
        otherEntity.collect()
        if(heart<3)
            heart+=1
      }
    }
    // 查看发生碰撞的是不是攻击物
    fixture.onContactChanged: {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "monster" || otherEntity.entityType === "spikes") {
        if(heart==0)
        {
          musicManager.playSound("playerDie")
          gameScene.resetLevel()
        }
        else {
             heart-=1
             musicManager.playSound("playerHit")
        }

      }
    }
 }

  //脚
  BoxCollider {
    id: feetSensor
    width: 32
    height: 10

    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.bottom

    bodyType: Body.Dynamic

    active: gameScene.state === "edit" ? false : true

    // Category2: player feet sensor
    categories: Box.Category2
    // Category3: opponent body, Category5: solids
    collidesWith: Box.Category3 | Box.Category5

    // this is only a sensor, so it should not physically collide
    // with any other object
    collisionTestingOnlyMode: true

    // this is called whenever the contact with another entity begins
    fixture.onBeginContact: {
      var otherEntity = other.getBody().target

      // if colliding with opponent...
      if(otherEntity.entityType === "opponent") {
        // ...calculate the lowest point of the player and
        // the opponent...
        var playerLowestY = player.y + player.height
        var oppLowestY = otherEntity.y + otherEntity.height

        // ...and if the player's y position is at least
        // 5px above the opponent's...
        if(playerLowestY < oppLowestY - 5) {
          // ...kill opponent...
          console.debug("kill opponent")
          otherEntity.die()

          // ...and jump in the air
          startJump(false)
        }
      }
      // else if colliding with another solid object...
      else if(otherEntity.entityType === "platform" || otherEntity.entityType === "ground") {
        // ...increase the player's contacts
        contacts++

        // if the player stands on this object...
        if(verticalVelocity >= 0)
          // ...set doubleJumpEnabled to true again
          doubleJumpEnabled = true
      }
    }

    // when contact ends
    fixture.onEndContact: {
      var otherEntity = other.getBody().target

      // when collision with another object ends, decrease the player's contacts
      if(otherEntity.entityType === "platform" || otherEntity.entityType === "ground")
        contacts--
    }
  }

  // this sensor makes sure, that the user can't draw/create any
  // entities close to the player
  BoxCollider {
    id: editorCollider

    anchors.fill: parent

    collisionTestingOnlyMode: true

    // Category16: misc
    categories: Box.Category16
  }

  /**
   * Update timer --------------------------------------------------------
   */

  // This timer is used to slow down the players horizontal movement,
  // when the controllers xAxis is in neutral position (0).
  // The collider's linearDamping property works similar, but also
  // slows down the vertical velocity - which we don't want.
  Timer {
    id: updateTimer

    // Set this interval as high as possible to improve performance,
    // but as low as needed so it still looks good.
    interval: 60

    running: true
    repeat: true

    onTriggered: {
      var xAxis = controller.xAxis;

      // if xAxis is 0 (no movement command) we slow the player down
      // until he stops
      if(xAxis == 0) {
        if(Math.abs(player.horizontalVelocity) > 10)
          player.horizontalVelocity *= decelerationFactor
        else
          player.horizontalVelocity = 0
      }
    }
  }

  /**
   * Invincibility ------------------------------------------------------
   */

  // this is the overlay image, that signals, that the player is invincible
  MultiResolutionImage {
    id: invincibilityOverlayImage

    source: "../../assets/player/player_rainbow.png"

    opacity: 0

    // this animation fades out the incibility overlay, to signal, that
    // the invincibility will end soon
    NumberAnimation on opacity {
      id: invincibilityOverlayImageFadeOut

      // slowly reduce opacity from 1 to 0
      from: 1
      to: 0

      // duration of the animation, in ms
      duration: 500
    }
  }

  // this timer is triggered shortly before invincibility ends, to signal,
  // that it will end soon
  Timer {
    id: invincibilityWarningTimer

    onTriggered: warnInvincibility()
  }

  // as long as this timer is running, the player is invincible
  // when it is triggered, invincibility ends
  Timer {
    id: invincibilityTimer

    onTriggered: endInvincibility()
  }

  /**
   * ascentControl ------------------------------------------------------
   */

  // The ascentControl allows the player to jump higher, when pressing the
  // jump button longer, and lower, when pressing the jump button shorter.
  // It is running while the player presses the jump button.
  Timer {
    id: ascentControl

    // every 15 ms this is triggered
    interval: 15
    repeat: true

    onTriggered: {
      // If jumpForceLeft is > 0, we set the players verticalVelocity to make
      // him jump.
      if(jumpForceLeft > 0) {

        var verticalImpulse = 0

        // At the beginning of the jump we set the verticalVelocity to 0 and
        // apply a high vertical impulse, to get a high initial vertical
        // velocity.
        if(jumpForceLeft == 20) {
          verticalVelocity = 0

          verticalImpulse = -normalJumpForce
        }
        // After the first strong impulse, we only want to increase the
        // verticalVelocity slower.
        else if(jumpForceLeft >= 14) {
          verticalImpulse = -normalJumpForce / 5
        }
        // Then, after about a third of our maximum jump time, we further
        // reduce the verticalImpulse.
        else {
          verticalImpulse = -normalJumpForce / 15
        }
        // Reducing the verticalImpulse over time allows for a more precise
        // controlling of the jump height.
        // Also it gives the jump a more natural feeling, than using a constant
        // value.

        // apply the impulse
        collider.applyLinearImpulse(Qt.point(0, verticalImpulse))

        // decrease jumpForceLeft
        jumpForceLeft--
      }
    }
  }

  /**
   * Item editor -----------------------------------------
   */
  // make properties editable via itemEditor
  EditableComponent {
    editableType: "Balance"
    properties: {
      "Player" : {
        "normalJumpForce": {"min": 0, "max": 400, "stepSize": 5, "label": "Jump Force"},
        "killJumpForce": {"min": 0, "max": 1000, "stepSize": 10, "label": "Kill Jump Force"},
        "accelerationForce": {"min": 0, "max": 5000, "stepSize": 10, "label": "Acceleration"},
        "maxSpeed": {"min": 0, "max": 400, "stepSize": 5, "label": "Speed"},
        "maxFallingSpeed": {"min": 5, "max": 1000, "stepSize": 5, "label": "Max Falling Speed"}
      },
      "Power-Ups" : {
        "starInvincibilityTime": {"min": 500, "max": 10000, "stepSize": 100, "label": "Star Duration (ms)"}
      }
    }
  }

  /**
   * Game related JS functions --------------------------------------------------
   */

  // This function is called, when the user presses the jump button or, when
  // the player jumps on an opponent.
  // isNormalJump is true, when the user pressed the jump button.
  // When jumping after a kill jump, isNormalJump is false.
  function startJump(isNormalJump) {
    if(isNormalJump) {
      // when the player stands on the ground and the jump
      // button is pressed, we start the ascentControl
      if(player.state == "walking") {
        ascentControl.start()
        audioManager.playSound("playerJump")
      }
      // if doubleJumpEnabled, the player can also jump without
      // standing on the ground
      else if(doubleJumpEnabled) {
        ascentControl.start()
        doubleJumpEnabled = false
        audioManager.playSound("playerJump")
      }
    }
    else {
      // When killing an opponent, we want the player to jump
      // a little. We do that by just setting the verticalVelocity
      // to a negative value.
      verticalVelocity = -killJumpForce
    }
  }

  // this function is called, when the user releases the jump button
  function endJump() {
    // stop ascentControl
    ascentControl.stop()

    // reset jumpForceLeft
    jumpForceLeft = 20
  }


  function startInvincibility(interval) {
    // this is the time the player is warned, that the invincibility will
    // end soon
    var warningTime = 500

    // the interval (invincibility time) must be at least as long as the
    // warning time
    if(interval < warningTime)
      interval = warningTime

    // show invincibility overlay
    invincibilityOverlayImage.opacity = 1

    // Calculate and set time until the invincibility warning.
    // This value is at least 0.
    invincibilityWarningTimer.interval = interval - warningTime
    // start timer
    invincibilityWarningTimer.start()

    // Calculate and set time until the invincibility ends.
    // This value is at least warningTime.
    invincibilityTimer.interval = interval
    // start timer
    invincibilityTimer.start()

    // enable invincibility
    invincible = true

    audioManager.playSound("playerInvincible")

    console.debug("start invincibility; interval: "+interval)
  }

  function warnInvincibility() {
    // fade out the invincibilityOverlayImage
    invincibilityOverlayImageFadeOut.start()

    console.debug("warn invincibility")
  }

  function endInvincibility() {
    // disable invincibility again
    invincible = false

    audioManager.stopSound("playerInvincible")

    console.debug("stop invincibility")
  }

  // changes the direction in which the player looks, depending on the direction
  // he moves in
  function changeSpriteOrientation() {
    if(controller.xAxis == -1) {
      image.mirrorX = true
      invincibilityOverlayImage.mirrorX = true
    }
    else if (controller.xAxis == 1) {
      image.mirrorX = false
      invincibilityOverlayImage.mirrorX = false
    }
  }

  /**
   * Start position JS functions -----------------------------------------------
   */

  // every time the player is released in edit mode, we update his start position
  onEntityReleased: updateStartPosition()

  function updateStartPosition() {
    startX = x
    startY = y
  }

  // this function tries to load the start position from a saved level, or sets
  // it to a default value
  function loadStartPosition() {
    // load startX if it is saved in the current level
    if(gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
        && gameWindow.levelEditor.currentLevelData["customData"]
        && gameWindow.levelEditor.currentLevelData["customData"]["playerX"]) {
      startX = parseInt(gameWindow.levelEditor.currentLevelData["customData"]["playerX"])
    }
    else {
      // if there is no startX saved, we set it to a default value
      startX = 32
    }

    // load startY if it is saved in the current level
    if(gameWindow.levelEditor && gameWindow.levelEditor.currentLevelData
        && gameWindow.levelEditor.currentLevelData["customData"]
        && gameWindow.levelEditor.currentLevelData["customData"]["playerY"]) {
      startY = parseInt(gameWindow.levelEditor.currentLevelData["customData"]["playerY"])
    }
    else {
      // if there is no startY saved, we set it to a default value
      startY = -96
    }
  }

  /**
   * Init and reset JS functions -------------------------------------
   */

  function initialize() {
    // load the player's start position from the level
    loadStartPosition()

    // reset the player
    reset()

    // set PlatformerEntityBaseDraggable's lastPosition property
    lastPosition = Qt.point(x, y)
  }

  function reset() {
    // reset position
    x = startX
    y = startY

    // reset velocity
    collider.linearVelocity.x = 0
    collider.linearVelocity.y = 0

    // reset score
    score = 0

    // reset doubleJumpEnabled
    doubleJumpEnabled = true

    // reset isBig
    isBig = false

    // reset invincibility
    invincible = false
    invincibilityTimer.stop()
    invincibilityWarningTimer.stop()
    invincibilityOverlayImage.opacity = 0
    audioManager.stopSound("playerInvincible")
  }

  function resetContacts() {
    // Reset the contacts to ensure the player starts each level
    // with zero contacts.
    contacts = 0
  }
}
