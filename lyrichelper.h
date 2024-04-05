#ifndef LYRICHELPER_H
#define LYRICHELPER_H

#include <QObject>

using LyricType = QPair<int, QString>;
class LyricHelper: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QList<LyricType> fromQString(QString string);
    Q_INVOKABLE QList<LyricType> fromQStringList(QStringList rawLines);
    Q_INVOKABLE QStringList toQStringList(QList<LyricType> lyrics);
    Q_INVOKABLE QString toQString(QList<LyricType> lyrics);
    Q_INVOKABLE QString lyricToQString(LyricType lyric);
};

#endif // LYRICHELPER_H
