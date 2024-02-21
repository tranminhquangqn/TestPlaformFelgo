import Felgo 4.0
import QtQuick 2.0
import "entities"
import "levels"

Scene {
    id: gameScene
    // the "logical size" - the scene content is auto-scaled to match the GameWindow size
    //  width: 480
    //  height: 320
    gridSize: 32
    property int offsetBeforeScrollingStarts: 240

    EntityManager {
        id: entityManager
    }

    // the whole screen is filled with an incredibly beautiful blue ...
    Rectangle {
        anchors.fill: gameScene.gameWindowAnchorItem
        //color: "#74d6f7"
        color:"black"
    }
    //player hp bar
    Rectangle{
        z:100
        x:50
        y:50
        width:  20
        height: 100
        color: "gray"
        radius: 2
        Item{
            anchors.fill: parent
            anchors.margins: 2
            Rectangle{
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                color: "green"
                width: parent.width
                height: parent.height*player.hp/100

            }
        }
    }

    // ... followed by 2 parallax layers with trees and grass
    ParallaxScrollingBackground {
        sourceImage: Qt.resolvedUrl("../assets/background/layer2.png")
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        // we move the parallax layers at the same speed as the player
        movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
        // the speed then gets multiplied by this ratio to create the parallax effect
        ratio: Qt.point(0.3,0)
    }
    ParallaxScrollingBackground {
        sourceImage: Qt.resolvedUrl("../assets/background/layer1.png")
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
        ratio: Qt.point(0.6,0)
    }

    // this is the moving item containing the level and player
    MouseArea {
        anchors.fill: parent
        onPressed: {
            autoShootTimer.start()
        }
        onReleased: {
            autoShootTimer.stop()
        }
        Timer {
            id: autoShootTimer
            interval: {
                switch(player.currentWeapon) {
                case 0:
                    return 100
                case 1:
                    return 200
                case 2:
                    return 100
                default:
                    return 100
                }
            }

            repeat: true
            triggeredOnStart: true
            onTriggered: {
                switch(player.currentWeapon) {
                case 0:
                    player.shootTo(parent.mouseX-viewPort.x, parent.mouseY-viewPort.y, player.currentWeapon)
                    break;
                case 1:
                    player.shootTo(parent.mouseX-viewPort.x, parent.mouseY-viewPort.y, player.currentWeapon)
                    break;
                case 2:
                    player.shootTo(parent.mouseX-viewPort.x, parent.mouseY-viewPort.y, player.currentWeapon)
                    break;
                default:
                    player.shootTo(parent.mouseX-viewPort.x, parent.mouseY-viewPort.y, player.currentWeapon)
                }
            }
        }
    }
    Item {
        id: viewPort
        height: level.height
        width: level.width
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        x: player.x > offsetBeforeScrollingStarts ? offsetBeforeScrollingStarts-player.x : 0


        PhysicsWorld {
            id: physicsWorld
            gravity: Qt.point(0, 30)
            debugDrawVisible: false // enable this for physics debugging
            z: 1000

            onPreSolve: contact => {
                            //this is called before the Box2DWorld handles contact events
                            var entityA = contact.fixtureA.getBody().target
                            var entityB = contact.fixtureB.getBody().target
                            if(entityB.entityType === "platform" && entityA.entityType === "player" &&
                               entityA.y + entityA.height > entityB.y) {
                                //by setting enabled to false, they can be filtered out completely
                                //-> disable cloud platform collisions when the player is below the platform
                                contact.enabled = false
                            }
                        }
        }

        // you could load your levels Dynamically with a Loader component here
        Level1 {
            id: level
        }

        Player {
            id: player
            x: 20
            y: 100
        }

        ResetSensor {
            width: player.width
            height: 10
            x: player.x
            anchors.top: viewPort.bottom
            anchors.margins: 100
            onContact: {
                player.x = 400
                player.y = 100
            }
            Rectangle {
                anchors.fill: parent
                color: "yellow"
                opacity: 0.5
            }
        }
    }

    Rectangle {
        // you should hide those input controls on desktops, not only because they are really ugly in this demo, but because you can move the player with the arrow keys there
        //visible: !system.desktopPlatform
        //enabled: visible
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: 50
        width: 150
        color: "blue"
        opacity: 0.4
        visible: false

        Rectangle {
            anchors.centerIn: parent
            width: 1
            height: parent.height
            color: "white"
        }
        MultiPointTouchArea {
            anchors.fill: parent
            onPressed: touchPoints => {
                           if(touchPoints[0].x < width/2)
                           controller.xAxis = -1
                           else
                           controller.xAxis = 1
                       }
            onUpdated: touchPoints => {
                           if(touchPoints[0].x < width/2)
                           controller.xAxis = -1
                           else
                           controller.xAxis = 1
                       }
            onReleased: controller.xAxis = 0
        }
    }

    //  Rectangle {
    //    // same as the above input control
    //    //visible: !system.desktopPlatform
    //    //enabled: visible
    //    anchors.left: parent.left
    //    anchors.bottom: parent.bottom
    //    height: 100
    //    width: 100
    //    color: "green"
    //    opacity: 0.4

    //    Text {
    //      anchors.centerIn: parent
    //      text: "jump"
    //      color: "white"
    //      font.pixelSize: 9
    //    }
    //    MouseArea {
    //      anchors.fill: parent
    //      onPressed: player.jump()
    //    }
    //  }

    // on desktops, you can move the player with the arrow keys, on mobiles we are using our custom inputs above to modify the controller axis values. With this approach, we only need one actual logic for the movement, always referring to the axis values of the controller

    Keys.forwardTo: controller

    TwoAxisController {
        id: controller
        onInputActionPressed: (actionName, isPressed) => {
                                  //console.log("key pressed actionName " + actionName +"ispressed: "+isPressed)
                                  if(actionName === "up") {
                                      player.jump()
                                  } else if(actionName === "down") {
                                      player.dropDown()
                                  } else if (actionName === "shift" && player.state == "walking") {
                                      player.boostSpeed = true
                                  } else if (actionName === "ctrl") {
                                      if (isPressed) {
                                          player.dash()
                                      }
                                  }else if (actionName === "num1") {
                                      player.currentWeapon=1
                                  }else if (actionName === "num2") {
                                      player.currentWeapon=2
                                  }
                              }
        onInputActionReleased: {
            if (actionName === "shift") {
                player.boostSpeed = false
            }else if(actionName === "down") {
                player.isProne=false
            }
        }

        inputActionsToKeyCode: {
            "up": Qt.Key_W,
            "down": Qt.Key_S,
            "left": Qt.Key_A,
            "right": Qt.Key_D,
            "drop": Qt.Key_X,
            "space": Qt.Key_Space,
            "shift": Qt.Key_Shift,
            "ctrl": Qt.Key_Control,
            "num1": Qt.Key_1,
            "num2": Qt.Key_2
        }
    }
}

