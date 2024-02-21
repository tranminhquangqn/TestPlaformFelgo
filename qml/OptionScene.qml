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
    ListModel{
        id: listMenu
        ListElement{btn:"assa"}
        ListElement{btn:"Lsasaoad"}
        ListElement{btn:"Back"}
    }
    Button{
        onClicked:{
            mainStackView.currentIndex=0
        }
    }

}
