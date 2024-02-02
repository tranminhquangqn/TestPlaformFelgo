import Felgo 4.0
import QtQuick 2.0

EntityBase {
  id: player
  entityType: "player"
  width: 50
  height: 50

  // add some aliases for easier access to those properties from outside
  property alias collider: collider
  property alias horizontalVelocity: collider.linearVelocity.x
  property real xAccelerate: 1.2

  property bool boostSpeed: false
  property bool isProne: false
  onIsProneChanged: {
      if(isProne){
          player.height=25
      }else{
          player.height=50
      }
  }
  function dropDown() {
      player.y++
  }

  property int jumpCount: 0

  // the contactsY property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contactsY > 0 --> walking state
  property int contactsX: 0
  property int contactsY: 0

  property int currentWeapon: 0
  // property binding to determine the state of the player like described above
  state: contactsY > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  // here you could use a SpriteSquenceVPlay to animate your player
  MultiResolutionImage {
    anchors.fill: parent
    source: Qt.resolvedUrl("../../assets/player/run.png")
    fillMode :Image.Stretch
  }

  BoxCollider {
    id: collider
    height: parent.height
    width: 30
    anchors.horizontalCenter: parent.horizontalCenter
    // this collider must be dynamic because we are moving it by applying forces and impulses
    bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
    fixedRotation: true // we are running, not rolling...
    bullet: true // for super accurate collision detection, use this sparingly, because it's quite performance greedy
    sleepingAllowed: false
    // apply the horizontal value of the TwoAxisController as force to move the player left and right
//    force: Qt.point(controller.xAxis*170*32,0)
    force: Qt.point(controller.xAxis * (player.boostSpeed ? 300 : 170) * 32, 0)
    // limit the horizontal velocity
    onLinearVelocityChanged: {
      if(linearVelocity.x > (player.boostSpeed ? 300 : 170)) linearVelocity.x = (player.boostSpeed ? 300 : 170)
      if(linearVelocity.x < -(player.boostSpeed ? 300 : 170)) linearVelocity.x = -(player.boostSpeed ? 300 : 170)
    }
  }

  // this timer is used to slow down the players horizontal movement. the linearDamping property of the collider works quite similar, but also in vertical direction, which we don't want to be slowed
  Timer {
    id: updateTimer
    // set this interval as high as possible to improve performance, but as low as needed so it still looks good
    interval: 60
    running: true
    repeat: true
    onTriggered: {
      var xAxis = controller.xAxis;
      // if xAxis is 0 (no movement command) we slow the player down until he stops
      if(xAxis == 0) {
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= xAccelerate
        else player.horizontalVelocity = 0
      }
    }
  }

//  function jump() { // 1 jump
//    console.debug("jump requested at player.state " + state)
//    if(player.state == "walking") {
//      console.debug("do the jump")
//      // for the jump, we simply set the upwards velocity of the collider
//      collider.linearVelocity.y = -300
//    }
//  }
  function jump() { //double jump
      console.debug("jump requested at player.state " + state)
      if (player.state == "walking" || (player.state == "jumping" && player.jumpCount < 2)) {
          console.debug("do the jump")
          // Increment jump count when jumping
          player.jumpCount += 1
          // for the jump, we simply set the upwards velocity of the collider
          collider.linearVelocity.y = -300
      }
  }
  onContactsYChanged: {
      // Reset jump count when the player lands on the ground
      if (contactsY > 0) {
          player.jumpCount = 0
      }
  }

  function dash() {
      console.debug("dash requested at player.state " + state)
      if (player.state == "walking") {
          console.debug("do the dash")
          // for the dash, set a higher horizontal velocity
          collider.linearVelocity.x = controller.xAxis * 500
      }
  }
//  EditableComponent {
//    target: player
//    editableType: "Balancing"
//    defaultGroup: "player"
//    properties: {
//      "xAccelerate": {"min": 1, "max": 10, "stepsize": 0.1 }
//    }
//  }
  property real shotSpeed: 500
//  function shootTo(targetX, targetY) {
//      var bulletComponent = Qt.createComponent("Bullet.qml")
//      if (bulletComponent.status === Component.Ready) {
//          var bullet = bulletComponent.createObject(player.parent)
//          if (bullet) {
//              // Calculate the direction towards the mouse position
//              var directionX = (targetX - player.x) / Math.sqrt((targetX - player.x) * (targetX - player.x) + (targetY - player.y) * (targetY - player.y))
//              var directionY = (targetY - player.y) / Math.sqrt((targetX - player.x) * (targetX - player.x) + (targetY - player.y) * (targetY - player.y))

//              // Set initial position and velocity
//              bullet.init(player.x+player.width/2, player.y+player.height/2, directionX * player.shotSpeed, directionY * player.shotSpeed)
//          }
//      } else {
//          console.error("Error loading Bullet component:", bulletComponent.errorString())
//      }
//  }
//  function shootTo(targetX, targetY) {
//      var bulletComponent = Qt.createComponent("Bullet.qml")

//      if (bulletComponent.status === Component.Ready) {
//          var bullet = bulletComponent.createObject(player.parent)
//          if (bullet) {
//              // Calculate the direction towards the mouse position
//              var directionX = (targetX - (player.x+player.width/2))
//              var directionY = (targetY - (player.y+player.height/2))
//              var length = Math.sqrt(directionX * directionX + directionY * directionY)

//              // Normalize the direction vector
//              directionX /= length
//              directionY /= length

//              // Set initial position and velocity
//              bullet.init(player.x+player.width/2, player.y+player.height/2, directionX * player.shotSpeed, directionY * player.shotSpeed)
//          }
//      } else {
//          console.error("Error loading Bullet component:", bulletComponent.errorString())
//      }
//  }
  function shootTo(targetX, targetY) {
      var bulletComponent = Qt.createComponent("Bullet.qml")

      if (bulletComponent.status === Component.Ready) {
          var bullet = bulletComponent.createObject(player.parent)
          if (bullet) {
              // Calculate the direction towards the mouse position
              var directionX = targetX - (player.x + player.width / 2)
              var directionY = targetY - (player.y + player.height / 2)
              var length = Math.sqrt(directionX * directionX + directionY * directionY)

              // Normalize the direction vector
              directionX /= length
              directionY /= length

              // Set initial position, exactly at the center of the player
              var bulletOffsetX = (bullet.width - player.width) / 2
              var bulletOffsetY = (bullet.height - player.height) / 2

              bullet.init(player.x - bulletOffsetX, player.y - bulletOffsetY, directionX * player.shotSpeed, directionY * player.shotSpeed)
          }
      } else {
          console.error("Error loading Bullet component:", bulletComponent.errorString())
      }
  }


}

