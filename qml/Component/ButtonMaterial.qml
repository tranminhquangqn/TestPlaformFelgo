import QtQml 2.3
import QtQuick 2.1
import QtQuick.Controls 2.1
//import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import "MaterialDesign"
Button {

    id: button
    // CUSTOM PROPERTIES
    property string _iconSourceOn: ""
    property string _iconSourceOff: ""
    property color _colorDefault: "transparent"
    property color _colorMouseOver: "#363435"
    property color _colorClicked: "#696969"
    property color _colorOverlayLow : "darkGray"
    property color _colorOverlayHigh : "#9cabff"
    property int _width: 70
    property int _height: 90
    property int _durationAnimation: 200
    property bool _enableEffect: true
    property bool _isToggleButton: false
    property bool _isClicked: false
    property int _size: 30
    property int _rotationIcon: 0
    property int _radius: 5
    property real _pressedScale: 0.8

    function startAnimation()
    {
        if (_isToggleButton){
            if(_enableEffect)
            {
                if(_isClicked)
                {
                    parallelAnimationUp.start()
                }
                else
                {
                    parallelAnimationDown.start()
                }
            }
        }
        else {
            if(_enableEffect)
            {
                parallelAnimation.start()
            }
        }

    }

    ParallelAnimation{
        id: parallelAnimation
        running: false

        SequentialAnimation{
            PropertyAnimation {
                properties: "color"
                target: background
                from: _colorDefault
                to: _colorClicked
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
            PropertyAnimation {
                properties: "color"
                target: background
                from: _colorClicked
                to: _colorDefault
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
        }
        SequentialAnimation{
            PropertyAnimation {
                properties: "color"
                target: icon
                from: _colorOverlayLow
                to: _colorOverlayHigh
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
            PropertyAnimation {
                properties: "color"
                target: icon
                from: _colorOverlayHigh
                to: _colorOverlayLow
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
        }
    }

    ParallelAnimation{
        id: parallelAnimationUp
        running: false
        SequentialAnimation{
            PropertyAnimation{
                properties: "color"
                target: background
                from: _colorDefault
                to: _colorClicked
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
            PropertyAnimation{
                properties: "color"
                target: background
                from: _colorClicked
                to: _colorDefault
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
        }

        PropertyAnimation{
            properties: "color"
            target: icon
            from: _colorOverlayLow
            to: _colorOverlayHigh
            duration: _durationAnimation
            easing.type: Easing.InCirc
        }
    }
    ParallelAnimation{
        id: parallelAnimationDown
        running: false
        SequentialAnimation{
            PropertyAnimation{
                properties: "color"
                target: background
                from: _colorDefault
                to: _colorClicked
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
            PropertyAnimation{
                properties: "color"
                target: background
                from: _colorClicked
                to: _colorDefault
                duration: _durationAnimation
                easing.type: Easing.InCirc
            }
        }
        PropertyAnimation{
            properties: "color"
            target: icon
            from: _colorOverlayHigh
            to: _colorOverlayLow
            duration: _durationAnimation
            easing.type: Easing.InCirc
        }
    }

    width: _width
    height: _height


    background: Rectangle{
        id: background
        color:  button.hovered ? button.pressed ? _colorClicked : _colorMouseOver : _colorDefault
        radius: _radius
        anchors.fill: parent

        MaterialDesignIcon {
            id: icon
            name: _isClicked ? _iconSourceOn : _iconSourceOff == "" ? _iconSourceOn : _iconSourceOff
            color:_isToggleButton?_isClicked ?_colorOverlayHigh:_colorOverlayLow:button.down ?  _colorOverlayHigh : _colorOverlayLow
            size: _size
            anchors.centerIn: parent
            rotation: _rotationIcon
            scale:_enableEffect ? button.pressed ? _pressedScale : 1.0 : 1.0
            Behavior on scale {
               enabled: _enableEffect
               NumberAnimation {
                   duration: _durationAnimation
               }
            }
        }
    }
}

