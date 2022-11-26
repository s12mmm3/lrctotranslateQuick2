#include "operatemgr.h"
#include "qcoreapplication.h"

#include <QFile>
#include <QUrl>
#include <QDateTime>
#include <QDir>

OperateMgr::OperateMgr()
{

}
QString OperateMgr::readFile(QString fileName) {
    QFile file(fileName);
    if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        file.setFileName(QUrl(fileName).toLocalFile());
        if(!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
            qDebug() << file.errorString();
            return "";
        }
    }
    auto result = file.readAll();
    file.close();
    return result;
}

bool OperateMgr::saveFile(QString fileName, QString content) {
    QFile file(fileName);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        file.setFileName(QUrl(fileName).toLocalFile());
        if(!file.open(QIODevice::ReadWrite)) {
            qDebug() << file.errorString();
            return false;
        }
    }
    file.write(content.toStdString().data());
    file.close();
    return true;
}

QString OperateMgr::getDetail() {
//    QDir dir = QDir::current();
//    qDebug() << QCoreApplication::applicationDirPath();
    return QStringLiteral("基于Qt%1编译\n"
                          "版本号:" APP_VERSION "\n"
                          "编译时间:%2\n"
                          "系统:%3")
            .arg(QT_VERSION_STR)
            .arg(__DATE__)
            .arg(QSysInfo::prettyProductName());
}

