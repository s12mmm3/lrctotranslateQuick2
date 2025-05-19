#ifndef OPERATOR_H
#define OPERATOR_H

#include <QObject>
#include <QVariantMap>

class Operator: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString readFile(QString fileName);
    Q_INVOKABLE bool saveFile(QString fileName, QString content);
    Q_INVOKABLE QVariantMap getDetail();
};
#endif // OPERATOR_H
