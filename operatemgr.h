#ifndef OPERATEMGR_H
#define OPERATEMGR_H

#include <QObject>

class OperateMgr: public QObject
{
    Q_OBJECT
public:
    OperateMgr();
    Q_INVOKABLE QString readFile(QString fileName);
    Q_INVOKABLE bool saveFile(QString fileName, QString content);
    Q_INVOKABLE QString getDetail();
};
#endif // OPERATEMGR_H
