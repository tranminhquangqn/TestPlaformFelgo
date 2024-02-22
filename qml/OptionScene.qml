import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Felgo

// EMPTY SCENE

Scene {
    id: optionScene
    ListModel{
        id: listOption
        ListElement{btn:"Control"}
        ListElement{btn:"Audio"}
        ListElement{btn:"Back"}
    }
    property int currentPick: 0
    Rectangle{
        id:settingLeftView
        anchors.left: parent.left
        anchors.top: parent.top
        height: parent.height
        width: parent.width*0.25
        color: "#201E1F"
        clip: true
        ListView{
            id: optionListview
            model: listOption
            height: parent.height*0.3
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.margins: 15
            delegate: Button{
                text: btn
                contentItem: Text{
                    text:parent.text
                    color:"white"
                    horizontalAlignment : Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter
                }
                height: optionListview.height/3
                background: null
                //     anchors.horizontalCenter: parent.horizontalCenter
                scale: index===currentPick?1.5:1
                onHoveredChanged: {
                    if(hovered)
                        currentPick=index
                }
                onClicked: {
                    switch(index) {
                    case 0:
                        break;
                    case 1:
                        mainStackView.currentIndex = 0
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
    StackLayout{
        id: settingView
        anchors.left: settingLeftView.right
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.leftMargin: 50
        anchors.rightMargin: 20
        currentIndex: currentPick
        Flickable{
            id: controlStack
            GroupBox{
                width: parent.width
                background:Rectangle{
                    color:"#201E1F"
                    radius: 10
                }
                Column{
                    Row{
                       Text{
                            text:"ADSdf"
                       }
                    }
                }
            }
        }
        Flickable{
            id: audioStack
            Column{
                Row{

                }
            }
        }

    }
}
