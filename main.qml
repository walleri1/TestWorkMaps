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

    function appendPoint(currentCoordinate, index) {
        let newCircleItem = Qt.createComponent("Point.qml")
        if (newCircleItem.status === Component.Ready) {
            newCircleItem = newCircleItem.createObject(maps, {coordinate: currentCoordinate, index: index})
        }
        maps.addMapItem(newCircleItem)
        mapPolygon.addCoordinate(currentCoordinate)
    }

    function translateMouseCoordinateToMapCoordinate(mouse) {
        return maps.toCoordinate(Qt.point(mouse.x, mouse.y))
    }

    PolygoneCore {
        id: polygoneCore

        onChangeCoordinatePolygon: {
            maps.clearMapItems()
            mapPolygon.path.forEach(item => {
                console.log(item)
                mapPolygon.removeCoordinate(item)
            })

            if (!coordinatePolygon.isEmpty)
                coordinatePolygon.forEach((item, index) => {
                    appendPoint(item, index)
                })
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
                color: 'red'
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                acceptedButtons: Qt.AllButtons
                hoverEnabled: true

                onClicked: {
                    if (mouse.button === Qt.LeftButton) {
                        const currentCoordinate = translateMouseCoordinateToMapCoordinate(mouse)
                        polygoneCore.newPoint(currentCoordinate)
                    } else if (mouse.button === Qt.RightButton) {
                        const currentCoordinate = translateMouseCoordinateToMapCoordinate(mouse)
                        maps.mapItems.forEach(item => {
                            if (currentCoordinate.distanceTo(item.coordinate) <= 100) {
                                  polygoneCore.delPoint(item.center)
                            }
                        })
                    }
                }

                onPositionChanged: {
                    const currentCoordinate = translateMouseCoordinateToMapCoordinate(mouse)
                    const button = (mouse.button === Qt.LeftButton) ? "left" : ((mouse.button === Qt.RightButton) ? "right" : "none");
                    polygoneCore.mouseEvent(currentCoordinate, button)
                }
            }
        }

    }
}
