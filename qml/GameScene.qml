import Felgo 4.0
import QtQuick 2.0
import QtQuick.Controls

import "entities"
import "levels"
import "Component"
import "Component/MaterialDesign"
Scene {
    id: gameScene
    gridSize: 32
    property int offsetBeforeScrollingStarts: (gameWindow.screenWidth/2-(player.width/viewPortScale.viewScale)/2)/viewPortScale.viewScale


    property int score: 0
    property int life: 10
    EntityManager {
        id: entityManager
    }
    Rectangle {
        anchors.fill: gameScene.gameWindowAnchorItem
        color:"black"
    }
    // HUD ///////////////////////////////////////////
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
    Button{
        // Zoom in button
        z:100
        x:100
        y:50
        width: 40
        text: "+"
        onClicked: {
        viewPortScale.viewScale+=0.1
        }
    }
    Button{
         // Zoom out button
        z:100
        x:150
        y:50
        width: 40
        text: "-"
        onClicked: {
        viewPortScale.viewScale-=0.1
        }
    }

    Item{
        width:50
        height:50
        z:100
        anchors.right: parent.right
        anchors.top: parent.top
        ButtonMaterial{
            id: stateTomoBtn
            anchors.fill:parent
            _width: 50
            _height: _width
            _size: _width * 0.75
            _iconSourceOn: "cogs"
            _iconSourceOff: ""
            anchors.centerIn: parent
            _enableEffect: true
            _colorOverlayHigh: "red"
            _pressedScale: 0.6
            onClicked: {
                ingameMenu.open()
            }
        }
    }
    Popup{
        id: ingameMenu
        width: 300
        height: 200
        anchors.centerIn: parent
        modal:true
        Rectangle{
            anchors.fill: parent
            color: "black"
        }
        ListModel{
            id: listOption
            ListElement{btn:"Resume"}
            ListElement{btn:"Option"}
            ListElement{btn:"Back to main menu"}
        }
        ListView{
            id: igMenu
            model: listOption
            height: parent.height*0.3
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 15
            property int currentPick: 0
            delegate: Button{
                text: btn
                contentItem: Text{
                    text:parent.text
                    color:"white"
                    horizontalAlignment : Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter
                }
                height: igMenu.height/3
                background: null
                scale: index===igMenu.currentPick?1.5:1
                onHoveredChanged: {
                    if(hovered)
                        igMenu.currentPick=index
                }
                onClicked: {
                    switch(index) {
                    case 0:
                        ingameMenu.close()
                        break;
                    case 1:
                        break;
                    case 2:
                        mainStackView.currentIndex = 0
                        break;
                    default:
                        // code block
                    }
                }
            }
        }
    }
    /////////////////////////////////////////
    ParallaxScrollingBackground {
        sourceImage: Qt.resolvedUrl("../assets/background/layer2.png")
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
        ratio: Qt.point(0.3,0)
    }
    ParallaxScrollingBackground {
        sourceImage: Qt.resolvedUrl("../assets/background/layer1.png")
        anchors.bottom: gameScene.gameWindowAnchorItem.bottom
        anchors.horizontalCenter: gameScene.gameWindowAnchorItem.horizontalCenter
        movementVelocity: player.x > offsetBeforeScrollingStarts ? Qt.point(-player.horizontalVelocity,0) : Qt.point(0,0)
        ratio: Qt.point(0.6,0)
    }
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
        transform: Scale {
            id: viewPortScale
            property real viewScale: 1
            origin.x: 0//gameWindow.screenWidth/2;
            origin.y: 0//gameWindow.screenHeight/2
            xScale:viewScale
            yScale:viewScale
            Behavior on viewScale {NumberAnimation{ duration:180}}
        }
        x: player.x/viewPortScale.viewScale > offsetBeforeScrollingStarts? offsetBeforeScrollingStarts-(player.x/viewPortScale.viewScale) : 0
        PhysicsWorld {
            id: physicsWorld
            gravity: Qt.point(0, 30)
            debugDrawVisible: false
            z: 1000
            onPreSolve: contact => {
                            var entityA = contact.fixtureA.getBody().target
                            var entityB = contact.fixtureB.getBody().target
                            if(entityB.entityType === "platform" && entityA.entityType === "player" &&
                               entityA.y + entityA.height > entityB.y) {
                               contact.enabled = false
                            }
                        }
        }
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
                                  else if (actionName === "enter") {
                                        popupMenuIg.show()
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
            "num2": Qt.Key_2,
            "enter": Qt.Key_Enter
        }
    }
    Popup{
        id:popupMenuIg
        width: 600
        height: 500
        Item{
            anchors.fill: parent
            Text{
                text: "Load game"
                color: "white"
                font.pointSize: 20
            }
            ListModel{
                id: saveList
                ListElement{btnName:"Save 1";btnIcon:"alert-circle"}
                ListElement{btnName:"Save 2";btnIcon:"alert-octagon"}
                ListElement{btnName:"Save 3";btnIcon:"alert-decagram"}
            }
            ListView{
                model: saveList
                height: parent.height*0.3
                width: parent.width
                anchors.centerIn: parent
                orientation : ListView.Horizontal
                spacing:30
                delegate: Item{
                    id:popupBtnDele
                    height: 170
                    width: 160
                    Rectangle{
                        color: "blue"
                        width: parent.width
                        height: parent.height*0.8
                        MaterialDesignIcon {
                            name: btnIcon
                            color: "white"
                            size: 100
                            anchors.centerIn: parent
                        }
                    }
                    Text{
                        anchors.bottom: parent.bottom
                        text: btnName
                        color:"white"
                    }
                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onHoveredChanged: {
                            if(containsMouse)
                               popupBtnDele.scale=1.1
                            else
                               popupBtnDele.scale=1
                        }
                    }
                }
            }
        }
    }
}

