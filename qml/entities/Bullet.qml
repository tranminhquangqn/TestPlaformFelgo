import Felgo 4.0
import QtQuick 2.0

EntityBase {
  id: bullet
  entityType: "bullet"
  width: 10
  height: 5
  Rectangle {
      width: parent.width
      height: parent.height
      color: "red"
  }
  BoxCollider {
    id: collider
    width: parent.width
    height: parent.height
    bodyType: Body.Dynamic
    fixedRotation: true
    bullet: true
  }

  Timer {
    id: lifeTimer
    interval: 10000  // Adjust the time the bullet stays alive
    onTriggered: {
      bullet.destroy()
    }
  }

  function init(positionX, positionY, velocityX, velocityY) {
    bullet.x = positionX
    bullet.y = positionY
    collider.linearVelocity.x = velocityX
    collider.linearVelocity.y = velocityY
    lifeTimer.start()
  }
}
