import QtQml 2.2
import QtQuick 2.1
import QtQuick.Controls 2.1
import QtGraphicalEffects 1.0
import QtQuick.Controls.Material 2.2

import "MaterialDesign"
Button {

    id: toggle_button
    // CUSTOM PROPERTIES
    property string _iconSourceOn: ""
    property string _iconSourceOff: ""
    property color _colorDefault: "transparent"
    property color _colorMouseOver: "#4A4A4A"
    property color _colorClicked: "#413F42"
    property color _colorOverlayLow : "darkGray"
    property color _colorOverlayHigh : "#21E1E1"
    property string _text :""
    property int _width: 70
    property int _height: 90
    property bool _isClicked: false
    property int _durationAnimation: 1000
    property bool _enableEffect: true
    property int _size: 30
    property bool _visbaleBackground: true

    function startAnimation(){
        if(_enableEffect)
            if(!_isClicked)
                parallelAnimationUp.start()
              else
                parallelAnimationDown.start()

    }
    ParallelAnimation{
        id: parallelAnimationUp
        running: false

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

        PropertyAnimation{
            properties: "color"
            target: background
            from: _colorClicked
            to: _colorDefault
            duration: _durationAnimation
            easing.type: Easing.InCirc
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
        color: _visbaleBackground ? toggle_button.hovered ?  _isClicked ? _colorClicked :_colorMouseOver : _isClicked ? _colorClicked : _colorDefault : "transparent"
        radius: 5
        anchors.fill: parent
        anchors.verticalCenter: parent.verticalCenter
        MaterialDesignIcon {
            id: icon
            name: _isClicked ? _iconSourceOn : _iconSourceOff == "" ? _iconSourceOn : _iconSourceOff
            color: toggle_button.down ?  _isClicked ?  _colorOverlayHigh : _colorOverlayLow : _isClicked ?  _colorOverlayHigh : _colorOverlayLow
            size: _size
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
        }
    }
    onClicked: {
        _enableEffect ? !_isClicked ? parallelAnimationUp.start() : parallelAnimationDown.start() : undefined
        _isClicked = !_isClicked
    }
}

