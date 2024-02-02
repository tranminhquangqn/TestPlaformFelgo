import QtQuick
import QtQuick.Controls
import Felgo

// EMPTY SCENE

Scene {

    Text {
        text: "Felgo"
        color: "blue"

        anchors.centerIn: parent
    }
    Button{
        onClicked: {
            mainStackView.currentIndex=1
        }
    }
    ListView{
        width: parent.width/2
        height: parent.height/2
        anchors.horizontalCenter: parent.horizontalCenter
    }

}
