import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Felgo

import "Component"
import "Component/MaterialDesign"

Scene {
    id: optionScene
    ListModel{
        id: listOption
        ListElement{btn:"Control"}
        ListElement{btn:"Video"}
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
        Rectangle{
            color:"green"
        }
        Flickable{
            id: controlStack
//            contentWidth: itemscontent.width
//            contentHeight: itemscontent.height
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{}
            GroupBox{
                id: videoGrb
                width: parent.width
                background:Rectangle{
                    color:"#201E1F"
                    radius: 10
                }
                Column{
                    spacing: 20
                    Row{
                        width: implicitWidth
                        height: implicitHeight
                        spacing: 20
                        Item{
                            width: videoGrb.width / 3
                            height: 40
                            Text{
                                text: "System Log Font"
                                color: "white"
                                width: contentWidth
                                height: contentHeight
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                        }
                        ComboBoxCustom{
                            width: 200
                            height: 40
                            wheelEnabled: true
                            _model: ["Full screen",
                                    "Windowed",
                                    "Borderless Window"]
                            _bgCombobox: "#424242"
                            _bgPopup: "#424242"
                            _opacityPopup: 1.0
                            _fontSize: 14
                            modelDataColor: "white"
                        }
                    }
                    Row{
                        width: implicitWidth
                        height: implicitHeight
                        spacing: 20
                        Item{
                            width: videoGrb.width / 3
                            height: 40
                            Text{
                                text: "Resolution"
                                color: "white"
                                width: contentWidth
                                height: contentHeight
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                        }
                        ComboBoxCustom{
                            width: 200
                            height: 40
                            wheelEnabled: true
                            _model: ["960x640",
                                "1280x720",
                                "1920x1080"]
                            _bgCombobox: "#424242"
                            _bgPopup: "#424242"
                            _opacityPopup: 1.0
                            _fontSize: 14
                            modelDataColor: "white"
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
