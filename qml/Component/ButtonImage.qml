import QtQuick 2.0
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
/*




*/
Button{
    id: buttonImage
    anchors.fill: parent
    property color _colorOverlay: "transparent"
    property color _borderColorBackground: "transparent"
    property color _colorBtnHovered: "transparent"
    property color _colorBtnDown: "transparent"
    property color _colorBtnDefault: "transparent"
    property string _tooltipText: ""
    property string _sourceImage: ""
    property bool _visible: false
    property bool _stateButton: false

    flat: true
    visible: _visible
    enabled: parent.enabled
    opacity: enabled ? 1 : 0.1
    font.weight: Font.Light

    ToolTip{
        id: toolTip
        visible: buttonImage.hovered
        text: _tooltipText
        width:parent.width*0.8
        font.bold: false
        delay: 500
        timeout: 5000
        contentItem: Text{
            id: text
            height: contentHeight
            width: contentWidth
            text: toolTip.text
            color: "#ffffff"
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors{
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                leftMargin:2
                rightMargin:2
                bottomMargin:2
            }
        }

        background: Rectangle{
            x: text.x - toolTip.width
            y: text.y
            height: text.height
            width: 2*text.width + toolTip.width
            color: "transparent"
            radius: 3
        }
    }

    contentItem: Image{
        id: image
        source: qsTr(_sourceImage)
        width: parent.width
        height: parent.height
        fillMode: Image.PreserveAspectFit
        verticalAlignment: Image.AlignVCenter
        horizontalAlignment: Image.AlignHCenter
    }

    ColorOverlay{
        id: overlay
        anchors.fill: image
        source: image
        color: _colorOverlay
    }

    background: Rectangle{
        color: buttonImage.down ? (buttonImage.down ? _colorBtnDown : _colorBtnDefault) : (buttonImage.hovered ? _colorBtnHovered : _colorBtnDefault)
        border.color: _borderColorBackground
        anchors{
            top:parent.top
            left:parent.left
            right:parent.right
            bottom:parent.bottom
            topMargin:2
            rightMargin:2
            leftMargin:2
            bottomMargin:2
        }
        radius: 5
    }
}

