import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: bullet
    entityType: "bullet"
    width: bulletType===1?10:50
    height: 10
    z:50
    property int bulletType:1
    function accuracy(){
        switch(bulletType) {
        case 0:
            return 0.5
        case 1:
            return 0.5
        case 2:
            return 0.5
        default:
            // code block
        }
    }
    rotation: Math.atan2(collider.linearVelocity.y, collider.linearVelocity.x) * 180 / Math.PI
    Rectangle {
        width: parent.width
        height: parent.height
        color: {
            switch(bulletType) {
            case 0:
                return 0.5
            case 1:
                return "red"
            case 2:
                return "yellow"
            default:
                // code block
            }
        }
        radius:width/2
    }
    BoxCollider {
        id: collider
        width: parent.width
        height: parent.height
        bodyType: Body.Dynamic
        fixedRotation: false
        bullet: true
        restitution : 0.3
        gravityScale: 0.4
        categories: Box.Category3
        collidesWith: Box.Category2| Box.Category4
        fixture.onBeginContact: (other, contactNormal) => {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "breakable") {
                bullet.destroy()
                otherEntity.hitted()
            }
        }
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
