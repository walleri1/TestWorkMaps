import QtQuick 2.15
import QtPositioning 5.15
import QtLocation 5.15

MapQuickItem {

    property int index: 0
    property real radius: 100

    anchorPoint: Qt.point(2.5,2.5)
    zoomLevel: 10

    MouseArea {
        anchors.fill: parent
        drag.target: parent
    }

    sourceItem: Rectangle {
        id: rect
        width: 32
        height: width
        radius: radius
        color: 'green'

        Text {
            anchors.centerIn: parent
            text: qsTr("%1").arg(index)
        }
    }
}
