import QtQuick 2.2
import QtQuick.Controls 2.2
import QtQml 2.2

import "./MaterialDesign"

Rectangle{
    id: rootSlider
    color: "transparent"
    signal handlePress()
    signal handleDoubleClicked()
    signal handleOnMoved()
    signal minValueChanged()
    signal maxValueChanged()
    signal minRHandleMoved()
    signal maxRHandleMoved()
    property int _mouseCombinedSlider: 0
    property bool _isEnableSlider: true
    property int _maxValueSlider: 0
    property int _initValueSlider: 0
    property int _stepTickerSlider: 1
    property int _fontPointSize: 15
    property string _fontFamily:  "Adobe Gothic Std B"
    property int _minArea4ticker: 25
    property int _distanceFromSlider2ticker: 20
    property var avalableStep: [1,2,5,10,20,50,100,200,500]
    property bool _isVertical: true
    property alias _currentValue: slider_custom.value
    property int _minValueRangeSlider: 0
    property int _maxValueRangeSlider: 0
    property bool _isEnableMaxRSlider: true
    property bool _isEnableMinRSlider: true
    property int _width: 0
    property int _height: 0

    width: _width
    height: _height
    rotation: _isVertical ? 90 : 0
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

    function setMaxHandle(index){
        if(rootSlider._isEnableMaxRSlider){
            _maxValueRangeSlider = index
            maxRSlider.visualX = (index-rootSlider._initValueSlider)*(rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width)/(_maxValueSlider - _initValueSlider) - maxRSlider.size/2 + slider_custom.leftPadding + slider_custom.handle.width/2
            rootSlider.maxValueChanged()
        }
    }

    function setMinHandle(index){
        if(rootSlider._isEnableMinRSlider){
            _minValueRangeSlider = index
            minRSlider.visualX = (index-rootSlider._initValueSlider)*(rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width)/(_maxValueSlider - _initValueSlider) - minRSlider.size/2 + slider_custom.leftPadding + slider_custom.handle.width/2
            rootSlider.minValueChanged()
        }
    }

    function getMaxValueRangeSlider(){
        var trueX = (maxRSlider.x + maxRSlider.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
        var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
        var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
        return trueIndex+1
    }

    function getMinValueRangeSlider(){
        var trueX = (minRSlider.x + minRSlider.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
        var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
        var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
        return trueIndex+1
    }
    function setValueSlider(value){
        if(_isEnableSlider){
            _currentValue = value
        }
    }
/*
//    Rectangle{
//        width: parent.width
//        height: 66
//        anchors.centerIn: parent
//        color: "transparent"
//        MaterialDesignIcon{
//            id: minRSlider
//            rotation: 90
//            anchors.top: parent.top
//            size: 30
//            name: "label-outline"
//            color: "gray"
//            property int value: 0
//            property int visualX: 0
//            onVisualXChanged: {
//                if (visualX <= maxRSlider.visualX){
//                    if (visualX <= 0){
//                        x = 0
//                    } else{
//                        x = visualX
//                    }

//                } else {
//                    x = maxRSlider.visualX
//                }
//            }
//            ToolTip {
//                parent: minRSlider
//                visible: handleMouseArea.interactHandle === minRSlider ? true : false
//                text: getMinValueRangeSlider().toFixed(0)
//                x: 10
//                y: -10
//                contentItem:Text{
//                    text:getMinValueRangeSlider().toFixed(0)
//                    color:"white"
//                    font.pointSize:8
//                }
//                background:Rectangle{
//                    color:"gray"
//                    radius:8
//                }
//            }
//        }

//        MaterialDesignIcon{
//            id: maxRSlider
//            rotation: 90
//            anchors.top: parent.top
//            size: 30
//            name: "label"
//            color: "gray"
//            property int visualX: 0
//            property int value: 0

//            onVisualXChanged: {
//                if (visualX >= minRSlider.visualX){
//                    if(visualX >= parent.width - 32){
//                        x = parent.width - 32
//                    }
//                    else{
//                        x = visualX
//                    }
//                } else {
//                    x = minRSlider.visualX
//                }
//            }
//            ToolTip {
//                parent: maxRSlider
//                visible: handleMouseArea.interactHandle === maxRSlider ? true : false
//                text: getMaxValueRangeSlider().toFixed(0)
//                x: 10
//                y: -10
//                contentItem:Text{
//                    text:getMaxValueRangeSlider().toFixed(0)
//                    color:"white"
//                    font.pointSize:8
//                }
//                background:Rectangle{
//                    color:"gray"
//                    radius:8
//                }
//            }
//        }
//        MouseArea{
//            id:handleMouseArea
//            width: parent.width
//            height: parent.height/2 - offset/2
//            anchors.top: parent.top
//            property var interactHandle
//            property int offset: 30

//            function sysPositionOfHandle(handleObj){
//                var trueX = (handleObj.x + handleObj.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
//                var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
//                var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
//                handleObj.x = trueIndex*trueWidth/(_maxValueSlider - _initValueSlider) - handleObj.size/2 + slider_custom.leftPadding + slider_custom.handle.width/2
//            }
//            function getMinValueRangeSlider(value){
//                var trueX = (value.x + value.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
//                var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
//                var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
//                return trueIndex +1
//            }
//            function getMaxValueRangeSlider(value){
//                var trueX = (value.x + value.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
//                var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
//                var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
//                return trueIndex +1
//            }
//            onPressed: {
//                if (maxRSlider.visualX < mouseX && maxRSlider.visualX + offset > mouseX && rootSlider._isEnableMaxRSlider){
//                    interactHandle = maxRSlider
//                    return
//                }
//                if (minRSlider.visualX < mouseX && minRSlider.visualX + offset > mouseX && rootSlider._isEnableMinRSlider){
//                    interactHandle = minRSlider
//                    return
//                }
////                console.log("hit nothing")
//            }
//            onPositionChanged: {
//                if (interactHandle !== undefined){
//                    interactHandle.visualX = mouseX - offset/2
//                    if(interactHandle === minRSlider){
//                        rootSlider._minValueRangeSlider = getMinValueRangeSlider(interactHandle)+1
//                        minRHandleMoved()
//                    }
//                    else if (interactHandle === maxRSlider){
//                        rootSlider._maxValueRangeSlider = getMaxValueRangeSlider(interactHandle)+1
//                        maxRHandleMoved()
//                    }
//                }
//            }

//            onReleased: {
//                if (interactHandle !== undefined){
//                    sysPositionOfHandle(interactHandle)
//                    interactHandle.visualX = interactHandle.x
//                }
//                interactHandle = undefined
//            }

//        }
//        Rectangle{
//            id:backgroundRSlider
//            x: minRSlider.x+ minRSlider.size/2
//            y:-(height-parent.height)/2
//            height:20
//            width: (maxRSlider.x - minRSlider.x)
//            radius: height/2
//            color:"#696969"
//            opacity: 0.8
//        }
//    }
*/
    Rectangle{
        id: ticker_root
        width: parent.width
        height: parent.height/2
        anchors.bottom: parent.bottom
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
                    y: 20
                    visible: x < ticker_root.width - slider_custom.handle.width
                    rotation: -90
                    color: "transparent"
                    Rectangle{
                        width: 20
                        height: 10
                        x: -1*_distanceFromSlider2ticker
                        color: "transparent"
                        Text{
                            width: 1
                            anchors.verticalCenter: parent.top
                            id: delegateText
                            text: String(index*_stepTickerSlider + _initValueSlider)
                            color: "white"
                            font.weight: Font.Normal
                            font.family: _fontFamily
                            horizontalAlignment: Text.AlignRight
                            font.pixelSize: _fontPointSize - 2
                            Rectangle{
                                width: 17
                                height: parent.contentWidth
                                color: "transparent"
                                anchors.centerIn: parent

                                Rectangle{
                                    width: 6
                                    height: 2
                                    color: "#7071B2"
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
            x: slider_custom.width - slider_custom.handle.width + slider_custom.leftPadding - minRSlider.width/5
            y: 20
            rotation: -90
            color: "transparent"
            Rectangle{
                width: 20
                height: 10
                x: -1*_distanceFromSlider2ticker
                color: "transparent"
                Text{
                    width: 1
                    anchors.verticalCenter: parent.top
                    text: _maxValueSlider
                    color: "white"
                    font.weight: Font.Normal
                    font.family: _fontFamily
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: _fontPointSize - 2
                    Rectangle{
                        width: 17
                        height: parent.contentWidth
                        color: "transparent"
                        anchors.centerIn: parent

                        Rectangle{
                            width: 6
                            height: 2
                            color: "#7071B2"
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.horizontalCenter: parent.right
                        }
                    }
                }
            }
        }
    }
    SliderCustom{
        id: slider_custom
        width: parent.width
        height: _mouseCombinedSlider
        anchors.centerIn: parent
        enabled: _isEnableSlider
        _maxValue: _maxValueSlider
        _from: _initValueSlider
        onMoved: rootSlider.handlePress()
        _horizoneLineWidth:107
        onValueChanged: {if(pressed)rootSlider.handleOnMoved()}
        onHandleDoubleClicked: {
            rootSlider.handleDoubleClicked()
        }

//        Rectangle{
//            anchors.fill: parent
//            color: "#AA8B56"
//            opacity: 0.5
//        }
        Rectangle{
            width: parent.width
            height: 30
            anchors.centerIn: parent
            color: "transparent"
            Rectangle{
                id: minRSlider
                width: size
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                property int value: 0
                property int visualX: 0
                property int size: 25
                onVisualXChanged: {
                    if (visualX <= maxRSlider.visualX){
                        if (visualX <= 0){
                            x = 0
                        } else{
                            x = visualX
                        }

                    } else {
                        x = maxRSlider.visualX
                    }
                }
                Rectangle{
                    width: 8
                    height:parent.height
                    color: "#7071B2"
                    anchors.centerIn: parent
                }
                ToolTip {
                    parent: minRSlider
                    visible: handleMouseArea.interactHandle === minRSlider ? true : false
                    text: getMinValueRangeSlider().toFixed(0)
                    x: 10
                    y: -10
                    contentItem:Text{
                        text:getMinValueRangeSlider().toFixed(0)
                        color:"white"
                        font.pointSize:8
                    }
                    background:Rectangle{
                        color:"gray"
                        radius:8
                    }
                }
            }
            Rectangle{
                id: maxRSlider
                width: size
                height:parent.height
                anchors.verticalCenter: parent.verticalCenter
                color: "transparent"
                property int visualX: 0
                property int value: 0
                property int size: 25
                onVisualXChanged: {
                    if (visualX >= minRSlider.visualX){
                        if(visualX >= parent.width - 30){
                            x = parent.width - 30
                        }
                        else{
                            x = visualX
                        }
                    } else {
                        x = minRSlider.visualX
                    }
                }
                Rectangle{
                    width: 8
                    height:parent.height
                    color: "#7071B2"
                    anchors.centerIn: parent
                }
                ToolTip {
                    parent: maxRSlider
                    visible: handleMouseArea.interactHandle === maxRSlider ? true : false
                    text: getMaxValueRangeSlider().toFixed(0)
                    x: 10
                    y: -10
                    contentItem:Text{
                        text:getMaxValueRangeSlider().toFixed(0)
                        color:"white"
                        font.pointSize:8
                    }
                    background:Rectangle{
                        color:"gray"
                        radius:8
                    }
                }
            }
            MouseArea{
                id:handleMouseArea
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                hoverEnabled: true
                cursorShape: Qt.ArrowCursor
                property var interactHandle
                property int offset: 30
                propagateComposedEvents: true
                signal mouseChanged()
                function sysPositionOfHandle(handleObj){
                    var trueX = (handleObj.x + handleObj.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
                    var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
                    var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
                    handleObj.x = trueIndex*trueWidth/(_maxValueSlider - _initValueSlider) - handleObj.size/2 + slider_custom.leftPadding + slider_custom.handle.width/2
                }
                function getMinValueRangeSlider(value){
                    var trueX = (value.x + value.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
                    var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
                    var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
                    return trueIndex +1
                }
                function getMaxValueRangeSlider(value){
                    var trueX = (value.x + value.size/2 - slider_custom.leftPadding - slider_custom.handle.width/2)
                    var trueWidth = rootSlider.width - slider_custom.leftPadding - slider_custom.rightPadding - slider_custom.handle.width
                    var trueIndex = Math.round((trueX/trueWidth)*(_maxValueSlider - _initValueSlider))
                    return trueIndex +1
                }
                onPressed: {
                    if (maxRSlider.visualX < mouseX && maxRSlider.visualX + offset > mouseX && rootSlider._isEnableMaxRSlider){
                        interactHandle = maxRSlider
                        return
                    }
                    if (minRSlider.visualX < mouseX && minRSlider.visualX + offset > mouseX && rootSlider._isEnableMinRSlider){
                        interactHandle = minRSlider
                        return
                    }
    //                console.log("hit nothing")
                    mouse.accepted = false
                }

                onPositionChanged: {
                    if (interactHandle !== undefined){
                        interactHandle.visualX = mouseX - offset/2
                        if(interactHandle === minRSlider){
                            rootSlider._minValueRangeSlider = getMinValueRangeSlider(interactHandle)+1
                            minRHandleMoved()
                        }
                        else if (interactHandle === maxRSlider){
                            rootSlider._maxValueRangeSlider = getMaxValueRangeSlider(interactHandle)+1
                            maxRHandleMoved()
                        }
                    }
                    mouseChanged()
                }
                onMouseChanged: {
                    if (maxRSlider.visualX < mouseX && maxRSlider.visualX + offset > mouseX && rootSlider._isEnableMaxRSlider){
                        handleMouseArea.cursorShape = Qt.SizeVerCursor
                    }
                    else if (minRSlider.visualX < mouseX && minRSlider.visualX + offset > mouseX && rootSlider._isEnableMinRSlider){
                        handleMouseArea.cursorShape = Qt.SizeVerCursor
                    }
                    else{
                        handleMouseArea.cursorShape = Qt.SizeAllCursor
                    }
                }
                onReleased: {
                    if (interactHandle !== undefined){
                        sysPositionOfHandle(interactHandle)
                        interactHandle.visualX = interactHandle.x
                    }
                    interactHandle = undefined
                }


            }
        }
        Rectangle{
            id:backgroundRSlider
            x: minRSlider.x+ minRSlider.width - 8 //
            y:-(height-parent.height)/2
            height:30
            z:parent.z-1
            width: (maxRSlider.x - minRSlider.x - 8)
            color:"#34313C"
        }
    }
    Timer{
        id:tmerSticker
        interval: 2000
        onTriggered: {
            _maxValueSliderChanged()
        }
    }
    Component.onCompleted: {
        setMaxHandle(_maxValueRangeSlider)
        setMinHandle(_minValueRangeSlider)
        tmerSticker.running = true
    }
}


