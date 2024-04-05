#ifndef LYRICHELPER_H
#define LYRICHELPER_H

#include <QObject>

using LyricType = QPair<int, QString>;
class Lyric: public LyricType {
public:
    Lyric();
    Lyric(int time, QString string);
    Q_INVOKABLE QString toQString();
};

class LyricHelper: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE QList<Lyric> fromQString(QString string);
    Q_INVOKABLE QList<Lyric> fromQStringList(QStringList rawLines);
    Q_INVOKABLE QStringList toQStringList(QList<Lyric> lyrics);
    Q_INVOKABLE QString toQString(QList<Lyric> lyrics);
};

#endif // LYRICHELPER_H
