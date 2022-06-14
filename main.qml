import QtQuick 2.15
import QtQuick.Controls 2.1
import QtQuick.Window 2.15
import QtPositioning 5.15
import QtLocation 5.15

import ru.radio.mmc.test.work 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 1000
    height: width
    title: qsTr("Редактор полигонов. Тестовое задание")

    PolygoneCore {
        id: polygoneCore

        onChangeCoordinatePolygon: {
            mapPolygon.path.forEach(item => {mapPolygon.removeCoordinate(item)})
            coordinatePolygon.forEach(item => {mapPolygon.addCoordinate(item)})
        }
    }

    Rectangle {
        id: container
        anchors.fill: parent

        Plugin
        {
            id: plugin
            name: "osm"
            parameters: [
                PluginParameter { name: "osm.useragent"; value: "My great Qt OSM application" },
                PluginParameter { name: "osm.mapping.host"; value: "http://osm.tile.server.address/" },
                PluginParameter { name: "osm.mapping.copyright"; value: "All mine" },
                PluginParameter { name: "osm.routing.host"; value: "http://osrm.server.address/viaroute" },
                PluginParameter { name: "osm.geocoding.host"; value: "http://geocoding.server.address" },
                PluginParameter { name: "osm.places.host"; value: "http://geocoding.server.address" }
            ]
        }

        Map {
            id: maps
            anchors.fill: parent
            plugin: plugin
            gesture.enabled: true
            gesture.acceptedGestures: MapGestureArea.PinchGesture | MapGestureArea.PanGesture | MapGestureArea.FlickGesture
            gesture.flickDeceleration: 3000
            zoomLevel: 11
            minimumZoomLevel: 1
            center: QtPositioning.coordinate(59.95, 30.30)

            MapPolygon {
                id: mapPolygon
                autoFadeIn: true
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                hoverEnabled: true

                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        const newCircleItem = Qt.createComponent("Point.qml").createObject(maps)
                        const currentCoordinate = maps.toCoordinate(Qt.point(mouse.x, mouse.y))
                        newCircleItem.center = currentCoordinate
                        newCircleItem.radius = 500.0
                        newCircleItem.color = 'green'
                        newCircleItem.border.width = 3

//                        mapPolygon.addCoordinate(newCircleItem.center)
                        maps.addMapItem(newCircleItem)
                        polygoneCore.newPoint(currentCoordinate)
                    } else if (mouse.button === Qt.RightButton) {
                        const currentCoordinate = maps.toCoordinate(Qt.point(mouse.x, mouse.y))
                        maps.mapItems.forEach(item => {
                                                if (currentCoordinate.distanceTo(item.center) <= item.radius) {
                                                      maps.removeMapItem(item)
                                                      mapPolygon.removeCoordinate(item.center)
                                                  }
                                              })
                    }
                }
            }
        }

    }
}
