import QtQml 2.2
import QtQuick 2.9
import QtQuick.Controls 2.2

import "./MaterialDesign"
Rectangle{
    id: rootSlider

    signal handlePress()
    signal handleDoubleClicked()
    signal handleOnMoved()
    property bool _isVertical: true
    property bool _isEnableSlider: true
    property int _maxValueSlider: 0
    property int _initValueSlider: 0
    property int _stepTickerSlider: 1
    property int _width: 0
    property int _height: 0
    property int _fontPointSize: 10
    property string _fontFamily:  "Adobe Gothic Std B"
    property int _minArea4ticker: 25
    property int _distanceFromSlider2ticker: 10
    property var avalableStep: [1,2,5,10,20,50,100,200,500]

    property alias _currentValue: slider_custom._value


    width: _isVertical?_height:_width
    height: _isVertical?_width:_height
    color: "transparent"
    rotation: _isVertical?90:0
    anchors.centerIn: parent

    on_MaxValueSliderChanged: {
        if(width <= 0 || height <= 0) return;
        var tmp = _maxValueSlider*_minArea4ticker/ticker_root.width
        for (var i=0; i<avalableStep.length; i++){
            if (avalableStep[i] > tmp){
                _stepTickerSlider = avalableStep[i]
                break
            }
        }
    }

    Column{
        width: parent.width
        height: parent.height
        spacing: 4
        anchors.centerIn: parent

        // slider
        Rectangle{
            width: _isVertical ? parent.width : parent.width*0.5 - parent.spacing/2
            height: _isVertical ? parent.height*0.5 - parent.spacing/2 : parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            SliderCustom{
                id: slider_custom
                anchors.centerIn: parent

                width: parent.width
                height: parent.height
                enabled: _isEnableSlider
                _maxValue: _maxValueSlider
                _from: _initValueSlider

                onMoved: rootSlider.handlePress()
                onHandleDoubleClicked: {rootSlider.handleDoubleClicked()}
                onValueChanged: {if(pressed)rootSlider.handleOnMoved()}
            }
        }
        // ticker frame
        Rectangle{
            id: ticker_root
            width: _isVertical ? parent.width : parent.width*0.5 - parent.spacing/2
            height: _isVertical ? parent.height*0.5 - parent.spacing/2 : parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"
            visible: slider_custom._maxValue > 0 ? true: false
            Row{
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                Repeater {
                    model: slider_custom.to / _stepTickerSlider +1
                    anchors.fill: parent
                    delegate: Rectangle{
                        width: 0
                        height: 0
                        x: slider_custom.leftPadding + slider_custom.handle.width/2 + index*((ticker_root.width - slider_custom.handle.width - slider_custom.leftPadding - slider_custom.rightPadding)/((slider_custom.to - slider_custom.from)/_stepTickerSlider))
                        y: 1
                        visible: x < ticker_root.width
                        rotation: _isVertical?-90:0
                        color: "transparent"
                        Rectangle{
                            width: 20
                            height: 10
                            x: -1*_distanceFromSlider2ticker
                            color: "transparent"
                            Text{
                                width: 1
                                anchors.verticalCenter: _isVertical?parent.top:undefined
                                anchors.horizontalCenter: _isVertical?undefined:parent.horizontalCenter
                                id: delegateText
                                text: String(index*_stepTickerSlider + _initValueSlider)
                                color: "white"
                                font.weight: Font.Normal
                                font.family: _fontFamily
                                horizontalAlignment: _isVertical?Text.AlignRight:Text.AlignHCenter
                                font.pixelSize: _fontPointSize - 2
                                Rectangle{
                                    width: 30
                                    height: parent.contentWidth
                                    color: "transparent"
                                    anchors.centerIn: parent
                                    rotation: _isVertical?0:-90

                                    Rectangle{
                                        width: 5
                                        height: 2
                                        color: "white"
                                        anchors.verticalCenter: parent.verticalCenter
                                        anchors.horizontalCenter: parent.right
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle{
                width: 0
                height: 0
                x: slider_custom.width - slider_custom.handle.width + slider_custom.leftPadding
                y: 1
                rotation: _isVertical?-90:0
                color: "transparent"
                Rectangle{
                    width: 20
                    height: 10
                    x: -1*_distanceFromSlider2ticker
                    color: "transparent"
                    Text{
                        width: 1
                        anchors.verticalCenter: _isVertical?parent.top:undefined
                        anchors.horizontalCenter: _isVertical?undefined:parent.horizontalCenter
                        text: _maxValueSlider
                        color: "white"
                        font.weight: Font.Normal
                        font.family: _fontFamily
                        horizontalAlignment: _isVertical?Text.AlignRight:Text.AlignHCenter
                        font.pixelSize: _fontPointSize - 2
                        Rectangle{
                            width: 30
                            height: parent.contentWidth
                            color: "transparent"
                            anchors.centerIn: parent
                            rotation: _isVertical?0:-90

                            Rectangle{
                                width: 5
                                height: 2
                                color: "white"
                                anchors.verticalCenter: parent.verticalCenter
                                anchors.horizontalCenter: parent.right
                            }
                        }
                    }
                }
            }
//            Rectangle{
//                id: indication_tag
//                property int position: 0
//                x: slider_custom.leftPadding + slider_custom.handle.width/2 + (slider_custom.to / _stepTickerSlider - position/_stepTickerSlider)*((ticker_root.width - slider_custom.handle.width - slider_custom.leftPadding - slider_custom.rightPadding)/((slider_custom.to - slider_custom.from)/_stepTickerSlider))
//                y: -55
//                MaterialDesignIcon{
//                    name: "label-outline"
//                    size: 32
//                    anchors.centerIn: parent
//                    rotation: 90
//                    color: "gray"
//                    Text{
//                        anchors.top: parent.bottom
//                        x: -10
//                        y: -10
//                        rotation: 180
//                        text: String(indication_tag.position)
//                        horizontalAlignment: Text.AlignLeft
//                        width: parent.size
//                        color: "white"
//                        font.bold: true
//                    }
//                }
//            }
        }
    }
}
