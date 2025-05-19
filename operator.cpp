#include "operator.h"

#include <QFile>
#include <QUrl>
#include <QDateTime>
#include <QDir>

QString Operator::readFile(QString fileName) {
    QFile file(fileName);
    // 如果fileName是URL格式，则转换为本地路径
    if (fileName.startsWith("file://")) {
        file.setFileName(QUrl(fileName).toLocalFile());
    } else {
        file.setFileName(fileName);
    }
    if (!file.open(QFile::ReadOnly)) {
        return "";
    }
    auto result = file.readAll();
    file.close(); // 确保关闭文件
    return result;
}

bool Operator::saveFile(QString fileName, QString content) {
    QFile file(fileName);
    // 如果fileName是URL格式，则转换为本地路径
    if (fileName.startsWith("file://")) {
        file.setFileName(QUrl(fileName).toLocalFile());
    } else {
        file.setFileName(fileName);
    }
    if (!file.open(QFile::WriteOnly | QFile::Truncate)) {
        return false;
    }
    file.write(content.toUtf8());
    file.close(); // 确保关闭文件
    return true;
}

QVariantMap Operator::getDetail() {
    return {
        { "QT_VERSION_STR", QT_VERSION_STR },
        { "__DATE__", __DATE__ },
        { "prettyProductName", QSysInfo::prettyProductName() },
    };
}

