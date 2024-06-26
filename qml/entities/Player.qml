import Felgo 4.0
import QtQuick 2.0

EntityBase {
    id: player
    entityType: "player"
    width: 50
    height: 50

    property alias collider: collider
    property alias horizontalVelocity: collider.linearVelocity.x
    property real xAccelerate: 1.5

    property int hp: 100
    property bool boostSpeed: false
    property bool isProne: false
    property int currentWeapon: 1
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

    // property binding to determine the state of the player like described above
    state: contactsY > 0 ? "walking" : "jumping"
    onStateChanged: console.debug("player.state " + state)
    Rectangle{
        color:"blue"
        anchors.fill:parent
    }

    // here you could use a SpriteSquenceVPlay to animate your player
    MultiResolutionImage {
        anchors.fill: parent
        source: Qt.resolvedUrl("../../assets/player/megaman.png")
        fillMode :Image.Stretch
    }

    BoxCollider {
        id: collider
        height: parent.height
        width: 30
        categories: Box.Category1
        anchors.horizontalCenter: parent.horizontalCenter
        // this collider must be dynamic because we are moving it by applying forces and impulses
        bodyType: Body.Dynamic // this is the default value but I wanted to mention it ;)
        fixedRotation: true // we are running, not rolling...
        bullet: true
        sleepingAllowed: false
        //    force: Qt.point(controller.xAxis*170*32,0)
        force: Qt.point(controller.xAxis * (player.boostSpeed ? 300 : 170) * 32, 0)
        onLinearVelocityChanged: {
            if(linearVelocity.x > (player.boostSpeed ? 300 : 170)) linearVelocity.x = (player.boostSpeed ? 300 : 170)
            if(linearVelocity.x < -(player.boostSpeed ? 300 : 170)) linearVelocity.x = -(player.boostSpeed ? 300 : 170)
        }
    }

    // this timer is used to slow down the players horizontal movement. the linearDamping property of the collider works quite similar, but also in vertical direction, which we don't want to be slowed
    Timer {
        id: updateTimer
        interval: 60
        running: true
        repeat: true
        onTriggered: {
            var xAxis = controller.xAxis;
            if(xAxis == 0) {
                if(Math.abs(player.horizontalVelocity) > 10) player.horizontalVelocity /= xAccelerate
                else player.horizontalVelocity = 0
            }
        }
    }

    //  function jump() { // 1 jump
    //    console.debug("jump requested at player.state " + state)
    //    if(player.state == "walking") {
    //      collider.linearVelocity.y = -300
    //    }
    //  }
    function jump() { //double jump
        if (player.state == "walking" || (player.state == "jumping" && player.jumpCount < 2)) {
            player.jumpCount += 1
            collider.linearVelocity.y = -300
        }
    }
    onContactsYChanged: {
        if (contactsY > 0) {
            player.jumpCount = 0
        }
    }

    function dash() {
        if (player.state == "walking") {
            collider.linearVelocity.x = controller.xAxis * 500
        }
    }

    function shootTo(targetX, targetY, bulletType) {
        var bulletComponent = Qt.createComponent("Bullet.qml")
        var shotSpeed
        switch(bulletType) {
        case 0:
            shotSpeed = 500
            break;
        case 1:
            shotSpeed = 1000 //pistol
            break;
        case 2:
            shotSpeed = 2000 //AK
            break;
        case 3:
            shotSpeed = 1500 //Rkman
            break;
//        default:
        }
        if (bulletComponent.status === Component.Ready) {
            var bullet = bulletComponent.createObject(viewPort,{bulletType:currentWeapon})
            if (bullet) {
                // Calculate the direction towards the mouse position
                var directionX = targetX - (player.x + player.width / 2)
                var directionY = targetY - (player.y + player.height / 2)
                var length = Math.sqrt(directionX * directionX + directionY * directionY)
                directionX /= length
                directionY /= length
                // Set initial position, exactly at the center of the player
                var bulletOffsetX = (bullet.width - player.width) / 2
                var bulletOffsetY = (bullet.height - player.height) / 2

                bullet.init(player.x - bulletOffsetX, player.y - bulletOffsetY, directionX * shotSpeed, directionY * shotSpeed)
            }
        }else {
            console.error("Error loading Bullet component:", bulletComponent.errorString())
        }
    }
}

