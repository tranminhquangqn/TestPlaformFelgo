import QtQuick 2.0
import Felgo 4.0
import "../"
TiledEntityBase {
    id: bunker
    entityType: "breakable"
    width: 200
    height: 200
    property int hp: 10
    function hitted(){
        hp--
        if(!hp){
            bunker.destroy()
        }
        hitOverlay.visible=true
        hittedTimer.restart()
    }
    Timer{
        id: hittedTimer
        interval: 60
        running: true
        onTriggered: {
            hitOverlay.visible=false
        }
    }
    Rectangle{
        anchors.fill: parent
        radius:5
        color:"brown"
    }
    Rectangle{
        id: hitOverlay
        visible: false
        radius:5
        anchors.fill: parent
        color:"white"
    }

    BoxCollider {
        id: collider
        anchors.fill: parent
        bodyType: Body.Static
        categories: Box.Category2
        fixture.onBeginContact: (other, contactNormal) => {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "player") {
                player.contactsY=1
            }
        }

        fixture.onEndContact: other => {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "player") {
                player.contactsY=0
            }
        }
    }
    function shootTo(targetX, targetY, bulletType) {
        var bulletComponent = Qt.createComponent("EBullet.qml")
        var shotSpeed = 500
        if (bulletComponent.status === Component.Ready) {
            var bullet = bulletComponent.createObject(viewPort,{bulletType:1})
            if (bullet) {
                var directionX = targetX - (bunker.x + bunker.width / 2)
                var directionY = targetY - (bunker.y + bunker.height / 2)
                var length = Math.sqrt(directionX * directionX + directionY * directionY)
                directionX /= length
                directionY /= length
                var bulletOffsetX = (bullet.width - bunker.width) / 2
                var bulletOffsetY = (bullet.height - bunker.height) / 2
                bullet.init(bunker.x - bulletOffsetX, bunker.y - bulletOffsetY, directionX * shotSpeed, directionY * shotSpeed)
            }
        }else {
            console.error("Error loading Bullet component:", bulletComponent.errorString())
        }
    }
    Timer {
        interval: 300
        repeat: true
        triggeredOnStart: true
        running: true
        onTriggered: {
            bunker.shootTo(player.x, player.y, 1)

        }
    }
}
