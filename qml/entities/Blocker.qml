import QtQuick 2.0
import Felgo 4.0

TiledEntityBase {
    id: platform
    entityType: "breakable"

    width: 200
    height: 200

//    property var hp: 10
    function hitted(){
//        hp--
//        if(!hp){
//            platform.destroy()
//        }

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

//    Row {
//        id: tileRow
//        Tile {
//            pos: "left"
//            image: Qt.resolvedUrl("../../assets/platform/left.png")
//        }
//        Repeater {
//            model: size-2
//            Tile {
//                pos: "mid"
//                image: Qt.resolvedUrl("../../assets/platform/mid" + index%2 + ".png")
//            }
//        }
//        Tile {
//            pos: "right"
//            image: Qt.resolvedUrl("../../assets/platform/right.png")
//        }
//    }
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
                console.debug("contact platform begin")
                // increase the number of active contacts the player has
                player.contactsY=1
            }
        }

        fixture.onEndContact: other => {
            var otherEntity = other.getBody().target
            if(otherEntity.entityType === "player") {
                console.debug("contact platform end")
                // if the player leaves a platform, we decrease its number of active contacts
                player.contactsY=0
            }
        }
    }
}
