#ifndef LYRICHELPER_H
#define LYRICHELPER_H

#include <QObject>
#include <QVariantMap>

/**
 * @brief 歌词格式
 * 歌词以JSON数组的形式组织，每个元素是一个包含歌词文本和时间的对象。
 *
 * 示例:
 * @code
 * [
 *   {
 *     "text": "覆い尽くす光彩",
 *     "time": 167800
 *   }
 * ]
 * @endcode
 */

using Lyric = QVariantMap;
using LyricList = QList<Lyric>;

/**
 * @class LyricHelper
 * @brief 歌词帮助器类，提供从字符串到歌词列表的转换功能。
 */
class LyricHelper: public QObject
{
    Q_OBJECT
public:
    /**
     * @fn fromQString
     * @brief 将字符串转换为歌词列表。
     * @param string 输入的歌词字符串。
     * @return 转换后的歌词列表。
     */
    Q_INVOKABLE LyricList fromQString(QString string);

    /**
     * @fn toQString
     * @brief 将歌词列表转换为字符串。
     * @param lyrics 输入的歌词列表。
     * @param fixed 小数点后保留位数，默认为3。
     * @param spaceStart 每行前的空格数，默认为0。
     * @param spaceEnd 每行后的空格数，默认为0。
     * @return 转换后的字符串。
     */
    Q_INVOKABLE QString toQString(LyricList lyrics, int fixed = 3, int spaceStart = 0, int spaceEnd = 0);
};

#endif // LYRICHELPER_H
