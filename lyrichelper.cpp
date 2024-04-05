#include "lyrichelper.h"

#include <QRegularExpression>

Lyric::Lyric() { }

Lyric::Lyric(int time, QString string): QPair<int, QString> ( time, string ) { }

QString Lyric::toQString()
{
    QString time;

    int pos = this->first;
    // 若时间<0，不插入时间轴
    if (pos >= 0) {
        int ms = pos % 1000;
        pos = pos / 1000;
        int s = pos % 60;
        int m = pos / 60;

        time = QString("[%1:%2.%3]")
                   .arg(m, 2, 10, QChar('0')) // 分
                   .arg(s, 2, 10, QChar('0')) // 秒
                   .arg(ms, 3, 10, QChar('0')); // 毫秒
    }

    return time + this->second;
}

LyricList Lyric::fromQString(QString string)
{
    LyricList lyricList;
    QStringList timeList;

    static QRegularExpression timeReg("\\[\\s*\\d+\\s*:\\s*\\d+(\\.\\d+)?\\s*\\]");  // 匹配时间标签

    int textPos = 0; // 非标签文本开始的位置

    // 匹配时间标签
    QRegularExpressionMatchIterator i = timeReg.globalMatch(string);
    while (i.hasNext()) {
        QRegularExpressionMatch match = i.next();
        timeList << match.captured(0);
        textPos = match.capturedEnd(0);
    }

    // 得到去除标签后的字符串
    QString strLeft = string.right(string.size() - textPos);

    if (timeList.size() > 0) {
        // 若一行包含多个时间，则拆分为不同时间轴、相同内容的歌词
        for(auto& time: timeList)
        {
            // 将时间标签转化为毫秒时间
            static auto reg = QRegularExpression("\\[|\\]");
            time.remove(reg);
            QStringList minSec = time.split(':');
            if(minSec.length() == 2) {
                int min = minSec.at(0).toInt();
                double sec = minSec.at(1).toDouble();
                int msec = min * 60 * 1000 + int(sec * 1000);
                lyricList.push_back({ msec, strLeft });
            }
        }
    }
    else {
        // 不存在时间轴，则插入一条时间为-1的歌词
        lyricList.push_back({ -1, strLeft });
    }
    return lyricList;
}

LyricList LyricHelper::fromQString(QString string)
{
    QStringList stringList;
    for(auto& line: string.split('\n', Qt::KeepEmptyParts))
    {
        line = line.trimmed();
        stringList.push_back(line);
    }
    return fromQStringList(stringList);
}

LyricList LyricHelper::fromQStringList(QStringList stringList)
{
    LyricList lyrics;
    for (auto & string: stringList) {
        LyricList lyricList = Lyric::fromQString(string);
        lyrics.append(lyricList);
    }
    return lyrics;
}

QStringList LyricHelper::toQStringList(QList<Lyric > lyrics)
{
    QStringList stringList;
    for (auto& lyric: lyrics) {
        stringList.push_back(lyric.toQString());
    }
    return stringList;
}

QString LyricHelper::toQString(QList<Lyric > lyrics)
{
    QString string;
    for(auto& lyric: toQStringList(lyrics))
    {
        string += (lyric + "\n");
    }

    return string;
}
