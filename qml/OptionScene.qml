import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Felgo
import QtQuick.Controls.Material

import "Component"
import "Component/MaterialDesign"

Scene {
    id: optionScene
    Material.theme: Material.Dark
    Material.accent: Material.Purple
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
                    id:optionListviewTabText
                    text:parent.text
                    color:"white"
                    horizontalAlignment : Text.AlignLeft
                    verticalAlignment : Text.AlignVCenter
                }
                height: optionListview.height/3
                background: null
                //anchors.horizontalCenter: parent.horizontalCenter
                scale: index===currentPick?1.5:1
                Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                onHoveredChanged: {
                    if(hovered){
                        optionListviewTabText.font.bold=true
                    }else{
                        optionListviewTabText.font.bold=false
                    }

                }
                onClicked: {
                    currentPick=index
                    switch(index) {
                    case 0:
                        break;
                    case 1:
                        break;
                    case 2:
                        break;
                    case 3:
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
            Text{
                anchors.centerIn: parent
                text: "control"
            }
        }
        Flickable{
            id: videoStack
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
                    Item{
                        height: 10
                    }

                    Row{
                        width: implicitWidth
                        height: implicitHeight
                        spacing: 20
                        Item{
                            width: videoGrb.width / 3
                            height: 40
                            Text{
                                text: "View type"
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
//            contentWidth: itemscontent.width
//            contentHeight: itemscontent.height
            boundsBehavior: Flickable.StopAtBounds
            ScrollBar.vertical: ScrollBar{}
            GroupBox{
                id: audioGrb
                width: parent.width
                background:Rectangle{
                    color:"#201E1F"
                    radius: 10
                }
                Column{
                    spacing: 20
                    Item{
                        height: 10
                    }
                    Row{
                        width: implicitWidth
                        height: implicitHeight
                        spacing: 20
                        Item{
                            width: audioGrb.width * 0.25
                            height: 40
                            Text{
                                text: "Volume"
                                color: "white"
                                width: contentWidth
                                height: contentHeight
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                        }
                        Slider {
                            id: sliderX
                            from: 0
                            to: 100
                            stepSize: 1
                            value: 20
                            wheelEnabled: true
                            width: audioGrb.width * 0.5
                            height: 40
                            //anchors.verticalCenter: parent.verticalCenter
                            background: Rectangle {
                                anchors.centerIn: parent
                                width: parent.width-sliderXHandle.width
                                height: 8
                                color: "#626ca6"
                                radius:3
                            }
                            handle: Rectangle {
                                id: sliderXHandle
                                x: sliderX.visualPosition * (sliderX.width - width)
                                y: (sliderX.height - height) / 2
                                color: "white"
                                width: 15
                                height: parent.height*0.6
                                radius: 3
                                MaterialDesignIcon {
                                    id: icon
                                    name: "equal"
                                    color: sliderX.pressed?"cyan":"black"
                                    size: parent.width
                                    anchors.centerIn: parent
                                    rotation: 90
                                }
                            }
                            onValueChanged: {

                            }
                        }
                        Item{
                            width: audioGrb.width * 0.25
                            height: 40
                            Text{
                                text: sliderX.value
                                color: "white"
                                width: contentWidth
                                height: contentHeight
                                anchors.fill: parent
                                horizontalAlignment: Text.AlignLeft
                                verticalAlignment: Text.AlignVCenter
                                font.pointSize: 12
                            }
                        }
                    }
                }
            }
        }
    }
}
