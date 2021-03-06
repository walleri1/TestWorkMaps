#ifndef TESTWORKMAPS_POLYGONECORE_H
#define TESTWORKMAPS_POLYGONECORE_H

#include <QObject>
#include <vector>
#include <QGeoCoordinate>
#include <QMouseEvent>

class PolygoneCore : public QObject {
    Q_OBJECT
    Q_PROPERTY(int count READ getCount)
public:
    explicit PolygoneCore(QObject *parent = nullptr);
    int getCount();

signals:
    void newPoint(const QGeoCoordinate& coordinate);
    void changeCoordinatePolygon(const QList<QGeoCoordinate> coordinatePolygon);
    void delPoint(const QGeoCoordinate& coordinate);
    void mouseEvent(const QGeoCoordinate& coordinate);

private slots:
    void addPoint(const QGeoCoordinate& coordinate);
    void removePoint(const QGeoCoordinate& coordinate);
    void mousePressEvent(const QGeoCoordinate& coordinate);

private:
    std::vector<QGeoCoordinate> coordinatePolygon;

private:
    std::vector<std::pair<QGeoCoordinate, double>> getVectorPairCoordinateDistance(const QGeoCoordinate& currentCoordinate);

    std::vector<std::pair<QGeoCoordinate, double>> getSortedVectorPairCoordinateDistance(const QGeoCoordinate &coordinate);
};


#endif //TESTWORKMAPS_POLYGONECORE_H
