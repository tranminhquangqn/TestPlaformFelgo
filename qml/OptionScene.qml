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
        onClicked:{
            mainStackView.currentIndex=0
        }
    }

}
