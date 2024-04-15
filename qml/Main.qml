import Felgo 4.0
import QtQuick 2.0
import QtQuick.Layouts
import QtQuick.Controls
GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://felgo.com/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the Felgo Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://felgo.com/licenseKey>"

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    activeScene: gameScene
    screenWidth: 200
    screenHeight: 200
    StackLayout {
        id:mainStackView
        anchors.fill: parent
        currentIndex: 0
        Rectangle{
            color:"black"
        }
        MainMenu{
            id:mainMenu
        }
        GameScene {
            id: gameScene
        }
        OptionScene{
            id: optionScene
        }
        onCurrentIndexChanged: {
            mainStackView.children[currentIndex].forceActiveFocus()
        }
    }
    /*
        player player   categories: Box.Category1
        bullet         categories: Box.Category3  collidesWith: Box.Category2| Box.Category4
        Blocker        categories: Box.Category2
        Ground         categories: Box.Category2
        Plaform        categories: Box.Category2
    */
}

