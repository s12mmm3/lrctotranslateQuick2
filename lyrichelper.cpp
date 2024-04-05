#include "lyrichelper.h"

#include <QRegularExpression>

Lyric::Lyric() { }

Lyric::Lyric(int time, QString string): LyricType ( time, string ) { }

QList<Lyric> LyricHelper::fromQString(QString string)
{
    QStringList lines;
    for(auto& line: string.split('\n'))
    {
        line = line.trimmed();
        if(!line.isEmpty()) lines.push_back(line);
    }

    return fromQStringList(lines);
}

QList<Lyric> LyricHelper::fromQStringList(QStringList stringList)
{
    QList<Lyric> lyrics;
    //进一步判断是否为LRC歌词
    QList<Lyric> lyricsTemp; //临时存放初步收集的可能无序的结果

    //这里判断的标准以 比较广泛的方式支持读取进来

    //网易云标准上传的歌词格式只有 带时间标签的行，而且一行一个时间 [xx:xx.xx]  xxx

    //广泛的lrc格式，可能包含 [ar:歌手名]、[ti:歌曲名]、[al:专辑名]、[by:编辑者(指lrc歌词的制作人)]、[offset:时间补偿值]
    //                    时间标签，形式为“[mm:ss]”或“[mm:ss.ff]”
    //                  一行可能包含多个时间标签

    QStringList infoLabels;     //储存非歌词行的信息 [ar:歌手名] 、[offset:时间补偿值] 等

    QRegularExpression timeReg("\\[\\s*\\d+\\s*:\\s*\\d+(\\.\\d+)?\\s*\\]");  //匹配时间标签
    QRegularExpression otherReg("\\[\\s*\\w+\\s*:\\s*\\w+\\s*\\]");  //匹配其他标签
    for(auto& line: stringList)
    {
        QStringList timeList;

        int textPos = 0; //非标签文本开始的位置

        // 匹配时间标签
        QRegularExpressionMatchIterator i = timeReg.globalMatch(line);
        while (i.hasNext()) {
            QRegularExpressionMatch match = i.next();
            timeList << match.captured(0);
            textPos = match.capturedEnd(0);
        }

        // 匹配其他标签
        QRegularExpressionMatchIterator j = otherReg.globalMatch(line);
        while (j.hasNext()) {
            QRegularExpressionMatch match = j.next();
            infoLabels << match.captured(0);
            textPos = match.capturedEnd(0);
        }

        // 得到去除标签后的字符串
        QString strLeft = line.right(line.size() - textPos);

        for(auto& time: timeList) //只有当收集到时间标签时，才收集对应的歌词进入 lrcLyricsTemp
        {
            //将时间标签转化为毫秒时间
            time.remove(QRegularExpression("\\[|\\]"));
            QStringList minSec = time.split(':');
            if(minSec.length() == 2) {
                int min = minSec.at(0).toInt();
                double sec = minSec.at(1).toDouble();
                int msec = min * 60 * 1000 + int(sec * 1000);
                lyricsTemp.push_back({ msec, strLeft });
            }
        }

        if(timeList.size() > 1)  //一行包含多个时间，认为不是标准的网易云音乐歌词
        {

        }
    }


    if(lyricsTemp.size() != 0)
    {
        //认为是lrc歌词

        //对收集到的 lrcLyricsTemp 根据时间，从小到大排序，置于  lrcLyrics 中

        while(lyricsTemp.size() != 0)
        {
            int minTime = lyricsTemp.front().first;
            auto iterDel = lyricsTemp.begin();           //存放最小的要被删除的那个
            for(auto iter = lyricsTemp.begin() + 1; iter != lyricsTemp.end(); iter++)
            {
                if(iter->first < minTime)
                {
                    iterDel = iter;
                    minTime = iter->first;
                }
            }

            lyrics.push_back(*iterDel);

            lyricsTemp.erase(iterDel);
        }

        if(infoLabels.size() != 0)//包含时间标签外的其他类型标签，认为不是标准的网易云音乐歌词
        {

        }
        // GatherInfoMap(infoLabels);

        // //查看 infoLabels中是否存在  [offset:时间补偿值]，存在则修正时间
        // if(offsetVaule != 0)
        // {
        //     for(auto& lrc: lrcLyrics)
        //     {
        //         lrc.first += offsetVaule;
        //         if(lrc.first < 0)
        //             lrc.first = 0;
        //     }
        // }

    }
    else
    {
        //找不到任何含有时间标签的行，认为是原生歌词

        //收集歌词到 lrcLyric 结构中，时间都置为 0
        for(auto& line: stringList)
        {
            lyrics.push_back({ 0, line });
        }
    }
    return lyrics;
}

QStringList LyricHelper::toQStringList(QList<Lyric > lyrics)
{
    QStringList rawLines;
    for (auto& lyric: lyrics) {
        rawLines.push_back(lyric.toQString());
    }
    return rawLines;
}

QString LyricHelper::toQString(QList<Lyric > lyrics)
{
    QString rawText;
    for(auto& lyric: toQStringList(lyrics))
    {
        rawText += (lyric + "\n");
    }

    return rawText;
}

QString Lyric::toQString()
{
    int pos = this->first;
    int ms = pos % 1000;
    pos = pos / 1000;
    int s = pos % 60;
    int m = pos / 60;

    QString timeLabel = QString("[%1:%2.%3]")
                            .arg(m, 2, 10, QChar('0')) // 分
                            .arg(s, 2, 10, QChar('0')) // 秒
                            .arg(ms, 3, 10, QChar('0')); // 毫秒

    return timeLabel + this->second;
}
