#include "gameprogress_vm.h"
#include <QFile>
#include <QJsonDocument>
#include <QJsonArray>
#include <QDebug>

GameProgress::GameProgress() : m_level(1), m_hp(100), m_def(10)
{

}

GameProgress::GameProgress(int level, int hp, int def) : m_level(level), m_hp(hp), m_def(def)
{

}

int GameProgress::level() const
{
    return m_level;
}

void GameProgress::setLevel(int level)
{
    m_level = level;
}

int GameProgress::hp() const
{
    return m_hp;
}

void GameProgress::setHp(int hp)
{
    m_hp = hp;
}

int GameProgress::def() const
{
    return m_def;
}

void GameProgress::setDef(int def)
{
    m_def = def;
}

bool GameProgress::saveToJson(const QString &fileName) const
{
    QFile saveFile(fileName);
    if (!saveFile.open(QIODevice::WriteOnly)) {
        qWarning("Couldn't open save file.");
        return false;
    }

    QJsonObject gameObject;
    gameObject["level"] = m_level;
    gameObject["hp"] = m_hp;
    gameObject["def"] = m_def;

    QJsonDocument saveDoc(gameObject);
    saveFile.write(saveDoc.toJson());

    return true;
}

bool GameProgress::loadFromJson(const QString &fileName)
{
    QFile loadFile(fileName);
    if (!loadFile.open(QIODevice::ReadOnly)) {
        qWarning("Couldn't open load file.");
        return false;
    }

    QByteArray saveData = loadFile.readAll();
    QJsonDocument loadDoc(QJsonDocument::fromJson(saveData));

    fromJson(loadDoc.object());

    return true;
}

QJsonObject GameProgress::toJson() const
{
    QJsonObject gameObject;
    gameObject["level"] = m_level;
    gameObject["hp"] = m_hp;
    gameObject["def"] = m_def;
    return gameObject;
}

void GameProgress::fromJson(const QJsonObject &json)
{
    m_level = json["level"].toInt();
    m_hp = json["hp"].toInt();
    m_def = json["def"].toInt();
}
/*
// Set some values
gameProgress.setLevel(3);
gameProgress.setHp(80);
gameProgress.setDef(15);

// Save game progress to JSON file
gameProgress.saveToJson("game_progress.json");

// Load game progress from JSON file
GameProgress loadedGameProgress;
loadedGameProgress.loadFromJson("game_progress.json");

// Output the loaded game progress
qDebug() << "Loaded Level:" << loadedGameProgress.level();
qDebug() << "Loaded HP:" << loadedGameProgress.hp();
qDebug() << "Loaded DEF:" << loadedGameProgress.def();

