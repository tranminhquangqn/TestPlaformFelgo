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
            height: parent.height*0.5
            Layout.alignment :Qt.AlignHCenter
            delegate: Button{
                text: btn
                height: mainMenuListview.height/3
                background: null
                Layout.alignment :Qt.AlignHCenter
                scale: index===currentPick?1.5:1
 //               Layout.horizontalCenter: parent.horizontalCenter
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
                        // code block
                        break;
                      case 2:
                        mainStackView.currentIndex=2
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

                   // event.accepted = true;
                }else{
                    currentPick--
                }
            }else if (event.key === Qt.Key_Down) {
                console.log("\nDown")
                if(currentPick==2){
                    currentPick=0
                }else{
                    currentPick++
                }
            }
        }
    }
}
