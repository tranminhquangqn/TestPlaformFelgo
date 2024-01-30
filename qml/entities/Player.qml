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

  // the contacts property is used to determine if the player is in touch with any solid objects (like ground or platform), because in this case the player is walking, which enables the ability to jump. contacts > 0 --> walking state
  property int contacts: 0
  // property binding to determine the state of the player like described above
  state: contacts > 0 ? "walking" : "jumping"
  onStateChanged: console.debug("player.state " + state)

  // here you could use a SpriteSquenceVPlay to animate your player
  MultiResolutionImage {
    source: Qt.resolvedUrl("../../assets/player/run.png")
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
    force: Qt.point(controller.xAxis*170*32,0)
    // limit the horizontal velocity
    onLinearVelocityChanged: {
      if(linearVelocity.x > 170) linearVelocity.x = 170
      if(linearVelocity.x < -170) linearVelocity.x = -170
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
        if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= 1.2
        else player.horizontalVelocity = 0
      }
    }
  }

  function jump() {
    console.debug("jump requested at player.state " + state)
    if(player.state == "walking") {
      console.debug("do the jump")
      // for the jump, we simply set the upwards velocity of the collider
      collider.linearVelocity.y = -300
    }
  }
}

