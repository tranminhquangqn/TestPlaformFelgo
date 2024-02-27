import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Window 2.3
import "MaterialDesign"

ComboBox {
    id: combobox
    property var _model: []
    property int _fontSize: 12
    property string _fontFamily: "Meiryo UI Regular"
    property color _bgCombobox: "#000000"
    property color _bgPopup: "#000000"
    property double _opacityPopup: 1.0
    property var modelDataColor: "white"

    model: _model
    delegate: ItemDelegate {
        width: combobox.width
        height: 30
        contentItem: Text {
            text: modelData
            color: modelDataColor
            font.pixelSize: combobox._fontSize
            font.family: combobox._fontFamily
            elide: Text.ElideRight
            verticalAlignment: Text.AlignVCenter
            leftPadding: 0
//            rightPadding: combobox.indicator.width + combobox.spacing
        }
        highlighted: combobox.highlightedIndex === index
    }
    indicator: MaterialDesignIcon {
        id: name
        name: "chevron-down"
        x: combobox.width - width - combobox.rightPadding/4
        y: combobox.topPadding + (combobox.availableHeight - height) / 2
        color: "white"
    }

    contentItem: Text {
        leftPadding: 15
        rightPadding: combobox.indicator.width + combobox.spacing
        text: combobox.displayText
        font.pixelSize: combobox._fontSize
        font.family: combobox._fontFamily
        color: "white"
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        color: combobox._bgCombobox
        radius: 2
    }

    popup: Popup {
        y: combobox.height-6
        width: combobox.width
        implicitHeight: contentItem.implicitHeight

        opacity: combobox.pressed ? 1.0 : combobox._opacityPopup
        padding: 0

        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: combobox.popup.visible ? combobox.delegateModel : null
            currentIndex: combobox.highlightedIndex
            ScrollIndicator.vertical: ScrollIndicator {}
        }
        background: Rectangle {
            radius: 2
            color: combobox._bgPopup
        }
    }
}


