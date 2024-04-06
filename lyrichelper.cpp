#include "lyrichelper.h"

#include <QRegularExpression>

namespace LyricImpl {
QString toTag(int time, int fixed);
QString toQString(Lyric lyric, int fixed, int spaceStart, int spaceEnd);
LyricList fromQString(QString string);
Lyric lyric(QString text, int time = -1);
};

QString LyricImpl::toTag(int time, int fixed)
{
    QString tag;
    int ms = time % 1000;
    time = time / 1000;
    int s = time % 60;
    int m = time / 60;

    tag = QString("[%1:%2.%3]")
              .arg(m, 2, 10, QChar('0')) // 分
              .arg(s, 2, 10, QChar('0')) // 秒
              .arg(ms, fixed, 10, QChar('0')); // 毫秒
    return tag;
}

QString LyricImpl::toQString(Lyric lyric, int fixed, int spaceStart, int spaceEnd)
{
    QString tag;

    int time = lyric.value("time", -1).toInt();
    // 若时间<0，不插入时间轴
    if (time >= 0) {
        tag = LyricImpl::toTag(time, fixed);
    }
    return tag
           + QString(spaceStart, ' ')
           + lyric.value("text", "").toString()
           + QString(spaceEnd, ' ');
}

LyricList LyricImpl::fromQString(QString string)
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
    QString strLeft = string.right(string.size() - textPos).trimmed();

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
                lyricList.push_back(lyric(strLeft, msec));
            }
        }
    }
    else {
        // 不存在时间轴，则插入一条不包含时间的歌词
        lyricList.push_back(lyric(strLeft));
    }
    return lyricList;
}

Lyric LyricImpl::lyric(QString text, int time)
{
    Lyric lyric = {
        { "text", text }
    };
    if (time >= 0) {
        lyric.insert("time", time);
    }
    return lyric;
}

LyricList LyricHelper::fromQString(QString string)
{
    LyricList lyrics;
    for(auto& line: string.split('\n', Qt::KeepEmptyParts))
    {
        line = line.trimmed();
        LyricList lyricList = LyricImpl::fromQString(line);
        lyrics.append(lyricList);
    }
    return lyrics;
}

QString LyricHelper::toQString(LyricList lyrics, int fixed, int spaceStart, int spaceEnd)
{
    QString string;
    for(auto& lyric: lyrics)
    {
        string.append(LyricImpl::toQString(lyric, fixed, spaceStart, spaceEnd)
                      + "\n");
    }
    return string;
}
