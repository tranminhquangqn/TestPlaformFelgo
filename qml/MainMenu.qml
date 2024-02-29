import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Felgo

Scene {
    id:mainMenuScene
    property int currentPick:0
    Rectangle {
        color: "black"
        anchors.fill: parent
    }
    ListModel{
        id: listMenu
        ListElement{btn:"New game"}
        ListElement{btn:"Load game"}
        ListElement{btn:"Option"}
        ListElement{btn:"Exit"}
    }
    ColumnLayout{
        anchors.fill: parent
        Item{
            Layout.alignment :Qt.AlignHCenter
            height: parent.height*0.3
            Text{
                anchors.centerIn: parent
                text:"AVBASF"
                color: "white"
            }
        }
        ListView{
            id: mainMenuListview
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
                scale: index===currentPick?1.5:1
                Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                onHoveredChanged: {
                    if(hovered)
                        currentPick=index
                }
                onClicked: {
                    switch(index) {
                      case 0:
                        mainStackView.currentIndex=1
                        break;
                      case 1:
                        mainVM.buttonCClicked()
                        break;
                      case 2:
                        mainStackView.currentIndex=2
                        break;
                      case 3:
                        Qt.quit()
                        break;
                      default:
                        // code block
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
    Item {
        anchors.fill: parent
        focus: true
        Keys.onPressed: (event)=> {
            if (event.key === Qt.Key_Up) {
                console.log("\nUP")
                if(currentPick==0){
                    currentPick=2
                }else{
                    currentPick--
                }
                event.accepted = true;
            }else if (event.key === Qt.Key_Down) {
                console.log("\nDown")
                if(currentPick==2){
                    currentPick=0
                }else{
                    currentPick++
                }
                event.accepted = true;
            }

        }
    }
}
