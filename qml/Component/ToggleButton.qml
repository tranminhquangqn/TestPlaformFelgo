import QtQml 2.2
import QtQuick 2.9
import QtQuick.Controls 2.2
import QtGraphicalEffects 1.0
/*



*/
Button{
    id:buttonText
    property int _width:100
    property int  _height:30
    property color _btnColorClicked:"transparent"
    property color _btnColorDefault:"#141414"
    property color _btnColorMouseOver :"lightslategray"
    property string _text:"None"
    property bool _enabled: true
    property bool  isOF:true


    height:_height
    width:_width
    enabled: _enabled
    QtObject{
        id: internalButtonText
        property var dynamicColor: if(buttonText.down){
                                       buttonText.down ? _btnColorClicked : _btnColorDefault
                                   } else {
                                       buttonText.hovered ? _btnColorMouseOver : _btnColorDefault
                                   }
    
    }
    onClicked:{
        if(isOF){
            isOF=false
            internalButtonText.dynamicColor = "limegreen"

        } else{
            isOF=true
            internalButtonText.dynamicColor =_btnColorDefault
        }
    }

    background:Rectangle{
        color: internalButtonText.dynamicColor
        radius:6
    }
    contentItem:Text{
        text:_text
        color:"white"
        font.pointSize:12
        font.family:"Adobe Gothic Std B" 
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment:Text.AlignHCenter           
    }
}
