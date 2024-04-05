#ifndef LYRICHELPER_H
#define LYRICHELPER_H

#include <QObject>

class Lyric: public QPair<int, QString> {
public:
    Lyric();
    Lyric(int time, QString string);

    QString toQString();
    static QList<Lyric> fromQString(QString string);
};

using LyricList = QList<Lyric>;
class LyricHelper: public QObject
{
    Q_OBJECT
public:
    Q_INVOKABLE LyricList fromQString(QString string);
    Q_INVOKABLE LyricList fromQStringList(QStringList rawLines);
    Q_INVOKABLE QStringList toQStringList(LyricList lyrics);
    Q_INVOKABLE QString toQString(LyricList lyrics);
};

#endif // LYRICHELPER_H
