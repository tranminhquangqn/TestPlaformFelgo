import QtQuick 2.9
import QtQml 2.3
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

Slider{
    property alias _value: slider.value
    property int _maxValue: 0
    property int _from: 0
    property var line_List: []
    property int _horizoneLineWidth: 0
    signal handleDoubleClicked()

    id: slider
    anchors.centerIn: parent
    stepSize: 1
    from: _from
    to: _maxValue
//    LayoutMirroring.enabled: true
    snapMode: Slider.SnapOnRelease


    background: Rectangle {
        id: background_slider
        x: slider.leftPadding
        y: slider.topPadding + slider.availableHeight / 2 - height / 2
        implicitWidth: 200
        implicitHeight: 4
        width: slider.availableWidth - 22 // Zed
        height: implicitHeight
        radius: 2
//        color: "#7071B2"
        color:"transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        Rectangle {
            width: parent.width - slider.visualPosition * parent.width
            height: parent.height
            anchors.right:parent.right
            color: "transparent"
            radius: 2
        }

    }

    handle: Rectangle {
        x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
        y:110
        implicitWidth: 20
        implicitHeight: 20
        radius: implicitWidth/2
        color: slider.pressed ? "aqua" : "#E5E3D7"
        border.color: "#BDBEBF"
        //horizone line
        Rectangle{
            implicitWidth: 200
            implicitHeight: 4
            width: _horizoneLineWidth
            color: slider.pressed ? "aqua" : "#E5E3D7"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 20
            rotation: 90
        }

        RectangularGlow {
            id: effect_fps
            anchors.fill: parent
            width:parent.width
            height:parent.height
            glowRadius: 15
            spread: 0.1
            color: slider.pressed ? "aqua": "transparent"
            cornerRadius: parent.radius + glowRadius
        }
        Text{
            text:slider.value.toFixed(0)
            anchors.centerIn: parent
            rotation: -90
            font.pointSize:8
        }
//        ToolTip {
//            parent: slider.handle
//            visible: slider.pressed
//            text: slider.value.toFixed(0)
//            x: 10
//            y: -10
//            contentItem:Text{
//                text:slider.value.toFixed(0)
//                color:"white"
//                font.pointSize:8
//            }
//            background:Rectangle{
//                color:"gray"
//                radius:8
//            }
//        }
        MouseArea{
            anchors.fill: parent
            propagateComposedEvents: true
            onPressed: {
                if(countDownDoubleClick.running === false){
                    countDownDoubleClick.running = true
                    mouse.accepted = false
                }
                else{
                    countDownDoubleClick.running = false
                    handleDoubleClicked()
                }
            }
        }
        Timer{
            id: countDownDoubleClick
            interval: 200
        }
    }
}
