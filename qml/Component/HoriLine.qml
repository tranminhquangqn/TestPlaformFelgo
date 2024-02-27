import QtQuick 2.0

Rectangle{
    property int _startX: parent.x
    property int _startY: parent.y
    property int _lenght: 0
    property int _thickness: 0
    property color _color: "transparent"

    x: _startX
    y: _startY
    width: _lenght
    height: _thickness
    color: _color
}
