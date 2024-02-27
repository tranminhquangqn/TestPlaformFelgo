import QtQuick 2.0
import QtQml 2.2

Rectangle{
    id: lineIndication
    color: "#b4b4b2"
    radius: width/2

    property int maxValue: 2
    property int startValue: 1
    property string indicationColor: "blue"

    property var objectList: []

    onMaxValueChanged: {
        clear()
    }

    function set(value){

        value = value - startValue
        var tmpRadius = 0
        var tmpHeight = height/(maxValue - startValue)
        var tmpY = (height*value/(maxValue - startValue)) - tmpHeight/2
        var tmpColor = '"' + indicationColor + '"'
        var edgeObject

        if (value === 0){
            tmpRadius = lineIndication.width
            tmpHeight = tmpHeight/2
            tmpY += tmpHeight
            edgeObject = Qt.createQmlObject('
                import QtQuick 2.0
                Rectangle{
                    width:'+width+'
                    color: ' + tmpColor + '
                    height: '+(tmpHeight/2)+'
                    y: '+(tmpY + tmpHeight/2)+'
                    anchors.horizontalCenter: lineIndication.horizontalCenter
                }
                ',
                lineIndication,
                "myDynamicSnippet"
            )
            lineIndication.objectList.push(edgeObject)
        }

        if (value === (maxValue - startValue)){
            tmpRadius = lineIndication.width
            tmpHeight = tmpHeight/2
            edgeObject = Qt.createQmlObject('
                import QtQuick 2.0
                Rectangle{
                    width:'+width+'
                    color: ' + tmpColor + '
                    height: '+(tmpHeight/2)+'
                    y: '+tmpY+'
                    anchors.horizontalCenter: lineIndication.horizontalCenter
                }
                ',
                lineIndication,
                "myDynamicSnippet"
            )
            lineIndication.objectList.push(edgeObject)
        }

        const newObject = Qt.createQmlObject('
            import QtQuick 2.0
            Rectangle{
                width:'+width+'
                color: ' + tmpColor + '
                radius: ' + tmpRadius + '
                height: '+tmpHeight+'
                y: '+tmpY+'
                anchors.horizontalCenter: lineIndication.horizontalCenter
            }
            ',
            lineIndication,
            "myDynamicSnippet"
        )
        lineIndication.objectList.push(newObject)

    }

    function clear(){
//        lineIndication._index = 0
        for (var i=0; i<lineIndication.objectList.length; i++){
            lineIndication.objectList[i].destroy()
        }
        lineIndication.objectList = []
    }
}
