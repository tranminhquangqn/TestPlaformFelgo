#ifndef GAMEPROGRESS_H
#define GAMEPROGRESS_H

#include <QJsonObject>

class GameProgress
{
public:
    GameProgress();
    GameProgress(int level, int hp, int def);

    int level() const;
    void setLevel(int level);

    int hp() const;
    void setHp(int hp);

    int def() const;
    void setDef(int def);

    bool saveToJson(const QString &fileName) const;
    bool loadFromJson(const QString &fileName);

    QJsonObject toJson() const;
    void fromJson(const QJsonObject &json);

private:
    int m_level;
    int m_hp;
    int m_def;
};

#endif // GAMEPROGRESS_H
