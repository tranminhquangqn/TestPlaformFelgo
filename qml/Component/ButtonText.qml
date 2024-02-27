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
    property int _sizeFont: 9
    property color _btnColorClicked:"transparent"
    property color _btnColorDefault:"#141414"
    property color _btnColorMouseOver :"dimgray"
    property string _text:""

    height:_height
    width:_width
    QtObject{
        id: internalButtonText
        property var dynamicColor: if(buttonText.down){
                                       buttonText.down ? _btnColorClicked : _btnColorDefault
                                   } else {
                                       buttonText.hovered ? _btnColorMouseOver : _btnColorDefault
                                   }

    }
    background:Rectangle{
        color: internalButtonText.dynamicColor
        radius: 5
    }
    contentItem:Text{
        text:_text
        color:"white"
        font.pointSize:_sizeFont
        font.bold: true
        font.family:"Adobe Gothic Std B" 
        verticalAlignment:Text.AlignVCenter
        horizontalAlignment:Text.AlignHCenter           
    }
}
