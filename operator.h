#ifndef OPERATOR_H
#define OPERATOR_H

#include <QObject>

class Operator: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QString readFile(QString fileName);
    Q_INVOKABLE bool saveFile(QString fileName, QString content);
    Q_INVOKABLE QString getDetail();
};
#endif // OPERATOR_H
