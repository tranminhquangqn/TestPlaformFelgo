import Felgo 4.0
import QtQuick 2.0

EntityBase {
  id: bullet
  entityType: "bullet"
  width: 10
  height: 5
  z:-1
  rotation: Math.atan2(collider.linearVelocity.y, collider.linearVelocity.x) * 180 / Math.PI
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
    fixedRotation: false
    bullet: true
    categories: Box.Category3
    collidesWith: Box.Category2
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
