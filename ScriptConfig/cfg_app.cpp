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
//    this->initVariable();
}

CfgApp::~CfgApp()
{
    this->writeFileConfig();
}
//void CfgApp::initVariable()
//{
//    status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERLAY_BTN]	 = m_bIsOnAllOverLay;
//    status_btn_on_systembar[SYSTEM_BAR_BUTTON::DEFECT_BTN]	 = m_bIsOnDefect;
//    status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERKILL_BTN] = m_bIsOnOverKill;
//    status_btn_on_systembar[SYSTEM_BAR_BUTTON::TRACKING_BTN] = m_bIsOnTracking;
//}

void CfgApp::readFileConfig()
{
    //    QMutexLocker locker(&mutex);
    try {
        if(!QDir(QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/TestSaveGame").exists()) {
            QDir().mkdir(QDir::homePath() + "/tomo_config");
        }

        // Check file exits and file empyt
//        fileConfig						  = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/ts_ui.json";
//        m_sConfigPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
        QFile file(fileConfig);
        if(!file.exists()) {
            m_saveName                                = "Save 001";
            m_nPort									  = 27025;
            m_sConfigPath							  = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
            m_bIsOnAllOverLay						  = true;
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

            m_saveName = rootObj.value("ServerName").toString();
            if(m_saveName == "")
                m_saveName = "TomO-Streaming";

            m_nPort = rootObj.value("Port").toInt();
            if(m_nPort == 0)
                m_nPort = 27025;

            m_sConfigPath = rootObj.value("ConfigPath").toString();
            if(m_sConfigPath == "")
                m_sConfigPath = QDir::homePath() + "/tomo_config/";

            m_bIsOnAllOverLay	= rootObj.value("IsOnAllOverLay").toBool();
        }
    }
    catch(const std::exception& e) {
        qDebug() << "Error when read file application config" << QString::fromStdString(e.what());
    }
}

////void MasterApp::setAfterUiCreated()
////{
////    Q_EMIT initAllOverlayBtn(m_bIsOnAllOverLay);
////    Q_EMIT initDefectBtn(m_bIsOnDefect);
////    Q_EMIT initOverKillBtn(m_bIsOnOverKill);
////    Q_EMIT initTrackingBtn(m_bIsOnTracking);
////}

void CfgApp::writeFileConfig()
{
    //    QMutexLocker locker(&mutex);
    QJsonObject rootObj;
    rootObj.insert("ServerName", QJsonValue::fromVariant(m_saveName));
    rootObj.insert("Port", m_nPort);
    rootObj.insert("ConfigPath", m_sConfigPath);
    rootObj.insert("IsOnAllOverLay", m_bIsOnAllOverLay);

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
