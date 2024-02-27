import QtQuick 2.9
import QtQml 2.2

Rectangle{
    id: mouseSellector
    property bool open: false
    property int _width: 0
    property int _height: 0
    visible: open

    width: open?_width:0
    height: open?_height:0

    Connections{
        target: mouseSellector_listModel
        onCloseAllWindow: {
            open = false
        }
    }

    function setOpen(lx, ly){
        mouseSellector_listModel.closeAllWindow()
        open = true
        if (ly + _height > parent.height){
            y = ly-_height
        } else {
            y = ly
        }

        if (lx + _width > parent.width){
            x =  lx - _width
        } else {
            x = lx
        }
    }
    function setClose(){
        mouseSellector_listModel.closeAllWindow()
    }

    color: "orange"

    ListView{
        id:mouseSellector_listView
        anchors.fill: parent
        model: mouseSellector_listModel
        interactive: false
        delegate: Rectangle{
            width: mouseSellector_listView.width
            height: mouseSellector_listView.height/4
            Rectangle{
                anchors.fill: parent
                color: localMouseArea.containsMouse?"#235c96":"#292a2b"
                border.width: 1
                border.color: localMouseArea.containsMouse?"#50a0f0":"#292a2b"
            }

            Text {
                anchors.fill: parent
                text: model.name
                verticalAlignment: Text.AlignVCenter
                leftPadding: 15
                font.pixelSize: 20
                color: model.status?"white":"#58584b"
            }
            MouseArea{
                id: localMouseArea
                anchors.fill: parent
                hoverEnabled: true
                onPressed: {
                    model.status = !model.status
                    systemBarVM.changedStatusButton(model.shorts, model.status)
                }
            }
            color: "#292a2b"
        }
    }
}
