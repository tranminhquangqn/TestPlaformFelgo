import QtQuick 2.2
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0

RangeSlider {
    id: rangeSlider

    property int _width: 0
    property int _height: 0
    property int _rotaion: 0
    property alias _maxValueSlider: rangeSlider.to
    property alias _initValueSlider: rangeSlider.from
    property alias _firstSlider: rangeSlider.first
    property alias _secondSlider: rangeSlider.second

    width: _width //Zed
    height: _height

    rotation: _rotaion
    anchors.centerIn: parent
    snapMode: RangeSlider.SnapOnRelease
    from: 0
    to: 0
    stepSize: 1
    background: Rectangle {
        x: rangeSlider.leftPadding
        y: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
        implicitWidth: parent.height
        implicitHeight: 4
        width: rangeSlider.availableWidth-3 //zed
        height: implicitHeight
        radius: 2
        color: "#bdbebf"

        Rectangle {
            x: ((rangeSlider.first.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * parent.width
            y: -(height-parent.height)/2
            width: ((rangeSlider.second.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * parent.width - x
            height: parent.height*6
            color: "#696969"
            opacity: 0.8
            radius: 5
        }
        Rectangle {
            x: ((rangeSlider.first.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * parent.width
            width: ((rangeSlider.second.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * parent.width - x
            height: parent.height
            color: "#7071B2"
            radius: 2
        }
    }

    first.handle: Rectangle {
        id: firtHandle
        x: rangeSlider.leftPadding + ((rangeSlider.first.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * (rangeSlider.availableWidth - width)
        y: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
        implicitWidth: 6
        implicitHeight: 25
        radius: 5
        color: rangeSlider.first.pressed ? "aqua" : "#f6f6f6"
        border.color: "#bdbebf"
        RectangularGlow {
            anchors.fill: parent
            width:parent.width
            height:parent.height
            glowRadius: 10
            spread: 0.1
            color: rangeSlider.first.pressed ? "aqua": "transparent"
            cornerRadius: parent.radius + 5
        }
        ToolTip {
            parent: rangeSlider.first.handle
            visible: rangeSlider.first.pressed
            text: rangeSlider.first.value.toFixed(0)
            x: -10
            y: 10
            contentItem:Text{
                text:rangeSlider.first.value.toFixed(0)
                color:"white"
                font.pointSize:8
            }
            background:Rectangle{
                color:"gray"
                radius:8
            }
        }
    }

    second.handle: Rectangle {
        x: rangeSlider.leftPadding + ((rangeSlider.second.value-rangeSlider.from)/(rangeSlider.to-rangeSlider.from)) * (rangeSlider.availableWidth - width)
        y: rangeSlider.topPadding + rangeSlider.availableHeight / 2 - height / 2
        implicitWidth: 6
        implicitHeight: 25
        radius: 5
        color: rangeSlider.second.pressed ? "aqua" : "#f6f6f6"
        border.color: "#bdbebf"
        RectangularGlow {
            anchors.fill: parent
            width:parent.width
            height:parent.height
            glowRadius: 10
            spread: 0.1
            color: rangeSlider.second.pressed ? "aqua": "transparent"
            cornerRadius: parent.radius + 5
        }
        ToolTip {
            parent: rangeSlider.second.handle
            visible: rangeSlider.second.pressed
            text: rangeSlider.second.value.toFixed(0)
            x: -10
            y: 10
            contentItem:Text{
                text:rangeSlider.second.value.toFixed(0)
                color:"white"
                font.pointSize:8
            }
            background:Rectangle{
                color:"gray"
                radius:8
            }
        }
    }
}
