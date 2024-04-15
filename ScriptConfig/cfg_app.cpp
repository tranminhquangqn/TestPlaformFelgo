#include "cfg_app.h"

#include <QDir>
#include <QFile>
#include <QTextStream>
#include <QStandardPaths>
#include <QJsonParseError>
#include <QJsonObject>
CfgApp::CfgApp()
{
    readFileConfig();
}

CfgApp::~CfgApp()
{
    this->writeFileConfig();
}

void CfgApp::readFileConfig()
{
    //    QMutexLocker locker(&mutex);
    try {
        if(!QDir(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/TestSaveGame").exists()) {
            QDir().mkdir(QDir::homePath() + "/tomo_config");
        }
        QFile file(fileConfig);
        if(!file.exists()) {
/*            m_saveName                                = "Save 001"*/;
            m_ScreenWidth									  = 1280;
            m_ScreenHeight									  = 720;
            m_GeneralVolume                                   = 0;
            m_isFullScreen                                	  = false;
            writeFileConfig();
            return;
        }
        else {
            file.open(QIODevice::ReadOnly | QIODevice::Text);
            QByteArray allData = file.readAll();
            file.close();
            QJsonParseError json_error;
            QJsonDocument jsonDoc = QJsonDocument::fromJson(allData, &json_error);
            QJsonObject rootObj	  = jsonDoc.object();

//            m_saveName = rootObj.value("SaveName").toString();
//            if(m_saveName == "")
//                m_saveName = "TomO-Streaming";

            m_ScreenWidth = rootObj.value("ScreenWidth").toInt();
            if(m_ScreenWidth < 0 || m_ScreenWidth > 2000)
                m_ScreenWidth = 1280;
            m_ScreenHeight = rootObj.value("ScreenHeight").toInt();
            if(m_ScreenHeight < 0 || m_ScreenHeight > 1500)
                m_ScreenHeight = 720;
            m_GeneralVolume = rootObj.value("ScreenHeight").toInt();
            if(m_GeneralVolume < 0 || m_GeneralVolume > 100)
                m_GeneralVolume = 0;
            m_isFullScreen	= rootObj.value("IsFullScreen").toBool();
        }
    }
    catch(const std::exception& e) {
        qDebug() << "Error when read file application config" << QString::fromStdString(e.what());
    }
}

void CfgApp::writeFileConfig()
{
    //    QMutexLocker locker(&mutex);
    QJsonObject rootObj;
//    rootObj.insert("SaveName", QJsonValue::fromVariant(m_saveName));
    rootObj.insert("ScreenWidth", m_ScreenWidth);
    rootObj.insert("ScreenHeight", m_ScreenHeight);
    rootObj.insert("GeneralVolume", m_GeneralVolume);
    rootObj.insert("IsFullScreen", m_isFullScreen);

    QJsonDocument jsonDoc;
    jsonDoc.setObject(rootObj);
    QByteArray byteArray = jsonDoc.toJson(QJsonDocument::Indented);
    QFile file(fileConfig);
    if(!file.open(QIODevice::WriteOnly | QIODevice::Text)) {
        qDebug() << QString("fail to open the file: %1, %2, %3").arg(__FILE__).arg(__LINE__).arg(__FUNCTION__);
        return;
    }
    QTextStream out(&file);
    out << byteArray;
    file.close();
}

//***********************************************
void CfgApp::setScreenWidth(int value)
{
    if(value != m_ScreenWidth) {
        m_ScreenWidth = value;
    }
}
void CfgApp::setScreenHeight(int value)
{
    if(value != m_ScreenHeight) {
        m_ScreenHeight = value;
    }
}
void CfgApp::setGeneralVolume(int value)
{
    if(value != m_GeneralVolume) {
        m_GeneralVolume = value;
    }
}
void CfgApp::setIsFullScreen(bool value)
{
    if(value != m_isFullScreen) {
        m_isFullScreen = value;
    }
}
int CfgApp::screenWidth()
{
    return m_ScreenWidth;
}
int CfgApp::screenHeight()
{
    return m_ScreenHeight;
}
int CfgApp::generalVolume()
{
    return m_GeneralVolume;
}
int CfgApp::isFullScreen()
{
    return m_isFullScreen;
}
