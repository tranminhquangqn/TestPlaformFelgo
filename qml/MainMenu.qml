import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Felgo

Scene {
    id:mainMenuScene
    Rectangle {
        color: "black"
        anchors.fill: parent
    }
    ColumnLayout{
        anchors.fill: parent
        visible: !saveFileMenu.visible
        Item{
            Layout.alignment :Qt.AlignHCenter
            height: parent.height*0.3
            Text{
                anchors.centerIn: parent
                text:"AVBASF"
                color: "white"
            }
        }
        ListModel{
            id: listMenu
            ListElement{btn:"New game"}
            ListElement{btn:"Load game"}
            ListElement{btn:"Option"}
            ListElement{btn:"Exit"}
        }
        ListView{
            id: mainMenuListview
            property int currentPick: 0
            model: listMenu
            height: parent.height*0.3
            Layout.alignment :Qt.AlignHCenter
            delegate: Button{
                text: btn
                contentItem: Text{
                    text:parent.text
                    color:"white"
                    horizontalAlignment : Text.AlignHCenter
                    verticalAlignment : Text.AlignVCenter
                }
                height: mainMenuListview.height/3
                background: null
                anchors.horizontalCenter: parent.horizontalCenter
                scale: index===mainMenuListview.currentPick?1.5:1
                Behavior on scale {
                    NumberAnimation { duration: 100 }
                }
                onHoveredChanged: {
                    if(hovered)
                        mainMenuListview.currentPick=index
                }
                onClicked: {
                    switch(index) {
                    case 0:
                        mainStackView.currentIndex=1
                        break;
                    case 1:
                        saveFileMenu.visible=true
                        break;
                    case 2:
                        mainStackView.currentIndex=2
                        break;
                    case 3:
                        Qt.quit()
                        break;
                    default:
                    }
                }
            }
        }
        Item{
            Layout.alignment :Qt.AlignHCenter
            height: parent.height*0.1
            Text{
                anchors.centerIn: parent
                text:"AVBASF"
                color:"white"
            }
        }
    }
    Item{
        id:saveFileMenu
        visible: false
        anchors.fill: parent
        Text{
            text: "Load game"
            color: "white"
            font.pointSize: 20
        }
        ListModel{
            id: saveList
            ListElement{sav:"Save 1"}
            ListElement{sav:"Save 2"}
            ListElement{sav:"Save 3"}
        }
        ListView{
            model: saveList
            height: parent.height*0.3
            width: parent.width
            anchors.centerIn: parent
            orientation : ListView.Horizontal
            spacing:30
            delegate: Item{
                id:saveListDelegate
                height: 170
                width: 160
                Rectangle{
                    color: "blue"
                    width: parent.width
                    height: parent.height*0.8
                }
                Text{
                    anchors.bottom: parent.bottom
                    text: sav
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
                           saveListDelegate.scale=1.1
                        else
                           saveListDelegate.scale=1
                    }
                }
            }
        }
        Button{
            id: loadGameBackBtn
            width:100
            height: 50
            text: "Back"
            anchors.bottom: parent.bottom
            onClicked: {
                saveFileMenu.visible=false
            }
        }
    }

    //    Item {
    //        anchors.fill: parent
    //        focus: true
    //        Keys.onPressed: (event)=> {
    //            if (event.key === Qt.Key_Up) {
    //                console.log("\nUP")
    //                if(mainMenuListview.currentPick==0){
    //                    mainMenuListview.currentPick=2
    //                }else{
    //                    mainMenuListview.currentPick--
    //                }
    //                event.accepted = true;
    //            }else if (event.key === Qt.Key_Down) {
    //                console.log("\nDown")
    //                if(mainMenuListview.currentPick==2){
    //                    mainMenuListview.currentPick=0
    //                }else{
    //                    mainMenuListview.currentPick++
    //                }
    //                event.accepted = true;
    //            }
    //        }
    //    }

}
