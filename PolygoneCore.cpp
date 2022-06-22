#include "PolygoneCore.h"
#include <QDebug>

PolygoneCore::PolygoneCore(QObject *parent) : QObject(parent) {
    coordinatePolygon.clear();

    connect(this, &PolygoneCore::newPoint, &PolygoneCore::addPoint);
    connect(this, &PolygoneCore::delPoint, &PolygoneCore::removePoint);
    connect(this, &PolygoneCore::mouseEvent, &PolygoneCore::mousePressEvent);
}

void PolygoneCore::addPoint(const QGeoCoordinate& coordinate) {
    if (coordinatePolygon.size() >= 3) {
        auto coordinateDistance = getSortedVectorPairCoordinateDistance(coordinate);

        for (auto it = coordinatePolygon.begin(); it != coordinatePolygon.end(); ++it) {
            if (*it == coordinateDistance[0].first) {
                coordinatePolygon.insert(it, coordinate);
                break;
            }
        }
    } else {
        coordinatePolygon.push_back(coordinate);
    }

    emit changeCoordinatePolygon(QList<QGeoCoordinate>::fromVector(QVector<QGeoCoordinate>::fromStdVector(coordinatePolygon)));
}

std::vector<std::pair<QGeoCoordinate, double>> PolygoneCore::getSortedVectorPairCoordinateDistance(const QGeoCoordinate &coordinate) {
    auto coordinateDistance = getVectorPairCoordinateDistance(coordinate);
    std::sort(coordinateDistance.begin(), coordinateDistance.end(), [](auto &left, auto &right) {
        return left.second < right.second;
    });
    return coordinateDistance;
}

std::vector<std::pair<QGeoCoordinate, double>> PolygoneCore::getVectorPairCoordinateDistance(const QGeoCoordinate& currentCoordinate) {
    std::vector<std::pair<QGeoCoordinate, double>> distanceCoordinate;

    for (auto &point: coordinatePolygon) {
        distanceCoordinate.emplace_back(point, point.distanceTo(currentCoordinate));
    }

    return distanceCoordinate;
}

void PolygoneCore::removePoint(const QGeoCoordinate& coordinate) {
    coordinatePolygon.erase(std::remove(coordinatePolygon.begin(), coordinatePolygon.end(), coordinate));

    emit changeCoordinatePolygon(QList<QGeoCoordinate>::fromVector(QVector<QGeoCoordinate>::fromStdVector(coordinatePolygon)));
}

int PolygoneCore::getCount() {
    return coordinatePolygon.size();
}

void PolygoneCore::mousePressEvent(const QGeoCoordinate& coordinate) {
    qDebug() << "mousePressEvent: " << coordinate.toString();
}
