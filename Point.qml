import QtQuick 2.15
import QtPositioning 5.15
import QtLocation 5.15

MapCircle {

    Text {
        id: label
        text: qsTr("Number")
        anchors.centerIn: parent
    }

    MouseArea {
        anchors.fill: parent
        drag.target: parent
    }
}
