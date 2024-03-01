#include "cfg_app.h"
//#include <yaml-cpp/yaml.h>

#include <QDir>
#include <QFile>
#include <QTextStream>


CfgApp::CfgApp(QObject* parent) : QObject{parent}
{
    readFileConfig();

    if(CfgApp::instance()->m_bIsTomOC) {
        CfgApp::instance()->trackNames.remove(1);
        CfgApp::instance()->trackNames.remove(1);
        CfgApp::instance()->docNames.remove("Optispec");
        CfgApp::instance()->docNames.remove("BOM");
    }

    for(int i = 0; i < CfgApp::instance()->trackNames.size(); i++) {
        this->track_view_models.insert(
            CfgApp::instance()->trackNames.at(i),
            QSharedPointer<TrackVM>::create(CfgApp::instance()->docNames.value(CfgApp::instance()->trackNames.at(i))));
        this->double_click_views.insert(CfgApp::instance()->trackNames.at(i), false);
    }

    // / Create and initialize top level station objects from here
    // / Udupa; Nov'22
    for(int i = 0; i < STATION_COUNT; i++)
        stream_tracks.push_back(nullptr);
    if(!CfgApp::instance()->m_bIsTomOC) {
        stream_tracks[STATION_OPTISPEC] = std::make_shared<OptispecStation>();
        stream_tracks[STATION_BOM]		= std::make_shared<BomStation>();
    }
    else {
        stream_tracks.pop_back();
        stream_tracks.pop_back();
    }
    stream_tracks[STATION_TOMOEYE] = std::make_shared<TomoEyeStation>();

    for(auto& track : stream_tracks) {
        track_status.push_back(track && track->initialize());
    }

    // tcp_server.StartServer(CfgApp::instance()->m_strServerName, CfgApp::instance()->m_nPort);

    this->initVariable();
}

MasterApp::~MasterApp()
{
    Q_FOREACH(QSharedPointer<TrackVM> value, track_view_models) {
        value.reset();
        delete value.data();
    }

    // qDebug() << "[MasterApp::~MasterApp] ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~`> Destructor call";
    this->writeFileConfig();
}

void MasterApp::broadcastPressButton(QString camCame, QString docName, bool isClick)
{
    Q_EMIT broadcastPressButtonSignal(camCame, docName, isClick);
}

void MasterApp::changedStatusButton(int type, bool status)
{
    switch(type) {
    case 0:
        status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERLAY_BTN] = status;
        CfgApp::instance()->m_bIsOnAllOverLay					= status;
        break;
    case 1:
        status_btn_on_systembar[SYSTEM_BAR_BUTTON::DEFECT_BTN] = status;
        CfgApp::instance()->m_bIsOnDefect					   = status;
        break;
    case 2:
        status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERKILL_BTN] = status;
        CfgApp::instance()->m_bIsOnOverKill						 = status;
        break;
    case 3:
        status_btn_on_systembar[SYSTEM_BAR_BUTTON::TRACKING_BTN] = status;
        CfgApp::instance()->m_bIsOnTracking						 = status;
        break;
    default:
        break;
    }

    this->writeFileConfig();
    Q_EMIT refreshViewSignal();
}

void MasterApp::initVariable()
{
    status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERLAY_BTN]	 = CfgApp::instance()->m_bIsOnAllOverLay;
    status_btn_on_systembar[SYSTEM_BAR_BUTTON::DEFECT_BTN]	 = CfgApp::instance()->m_bIsOnDefect;
    status_btn_on_systembar[SYSTEM_BAR_BUTTON::OVERKILL_BTN] = CfgApp::instance()->m_bIsOnOverKill;
    status_btn_on_systembar[SYSTEM_BAR_BUTTON::TRACKING_BTN] = CfgApp::instance()->m_bIsOnTracking;
}

void MasterApp::readFileConfig()
{
    //    QMutexLocker locker(&mutex);
    try {
        if(!QDir(QDir::homePath() + "/tomo_config").exists()) {
            QDir().mkdir(QDir::homePath() + "/tomo_config");
        }

        // Check file exits and file empyt
        fileConfig						  = QDir::homePath() + "/tomo_config/ts_ui.json";
        CfgApp::instance()->m_sConfigPath = QDir::homePath() + "/tomo_config/";
        QFile file(fileConfig);
        if(!file.exists()) {
            CfgApp::instance()->m_strServerName							  = "TomO-Streaming";
            CfgApp::instance()->m_nPort									  = 27025;
            CfgApp::instance()->m_sVideoFolderPath						  = "";
            CfgApp::instance()->m_nProcessingTomoImagingSignalFrequencyMs = 10;
            CfgApp::instance()->m_sConfigPath							  = QDir::homePath() + "/tomo_config/";
            CfgApp::instance()->m_nStreamingLenght						  = 0;
            CfgApp::instance()->m_nMinValueRSlider						  = 1;
            CfgApp::instance()->m_nMaxValueRSlider						  = 1;
            CfgApp::instance()->m_nValueSlider							  = 1;
            CfgApp::instance()->m_bIsOnAllOverLay						  = true;
            CfgApp::instance()->m_bIsOnDefect							  = true;
            CfgApp::instance()->m_bIsOnOverKill							  = true;
            CfgApp::instance()->m_bIsOnTracking							  = true;
            CfgApp::instance()->m_sTomOCamFocus							  = "TomoPose";
            CfgApp::instance()->m_sOptispecCamFocus						  = "OptiSpec";
            CfgApp::instance()->m_sBomCamFocus							  = "BOM";
            CfgApp::instance()->m_sHeadCamFocus							  = "TomoEye";
            CfgApp::instance()->m_bIsMaxTomOCam							  = false;
            CfgApp::instance()->m_bIsMaxOptispecCam						  = false;
            CfgApp::instance()->m_bIsMaxBomCam							  = false;
            CfgApp::instance()->m_bIsMaxHeadCam							  = false;
            CfgApp::instance()->m_sBgColorCmd							  = "#000000";
            CfgApp::instance()->m_sTextFontCmd							  = "Adobe Gothic Std B";
            CfgApp::instance()->m_nTextSizeCmd							  = 12;
            CfgApp::instance()->m_sTextColorCmd							  = "#FFFFFF";
            CfgApp::instance()->m_nLineSpacingCmd						  = 2;
            CfgApp::instance()->m_bDisplayPanelStatus					  = false;
            CfgApp::instance()->m_bMotionPanelStatus					  = false;
            CfgApp::instance()->m_nHeightOfSystemlog					  = 200;
            CfgApp::instance()->m_nYOfSystemlog							  = 858;
            CfgApp::instance()->m_nTabOfSystemlog						  = 0;
            CfgApp::instance()->m_bIsTomOC								  = false;
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

            CfgApp::instance()->m_strServerName = rootObj.value("ServerName").toString().toStdString();
            if(CfgApp::instance()->m_strServerName == "")
                CfgApp::instance()->m_strServerName = "TomO-Streaming";

            CfgApp::instance()->m_nPort = rootObj.value("Port").toInt();
            if(CfgApp::instance()->m_nPort == 0)
                CfgApp::instance()->m_nPort = 27025;

            CfgApp::instance()->m_sVideoFolderPath						  = rootObj.value("VideoFolderPath").toString();
            CfgApp::instance()->m_nProcessingTomoImagingSignalFrequencyMs = rootObj.value("ProcessingTomoImagingSignalFrequencyMs").toInt();
            if(CfgApp::instance()->m_nProcessingTomoImagingSignalFrequencyMs == 0)
                CfgApp::instance()->m_nProcessingTomoImagingSignalFrequencyMs = 10;

            CfgApp::instance()->m_sConfigPath = rootObj.value("ConfigPath").toString();
            if(CfgApp::instance()->m_sConfigPath == "")
                CfgApp::instance()->m_sConfigPath = QDir::homePath() + "/tomo_config/";

            CfgApp::instance()->m_nStreamingLenght = rootObj.value("StreamingLenght").toInt();
            CfgApp::instance()->m_nMinValueRSlider = rootObj.value("MinValueRSlider").toInt();
            if(CfgApp::instance()->m_nMinValueRSlider == 0)
                CfgApp::instance()->m_nMinValueRSlider = 1;

            CfgApp::instance()->m_nMaxValueRSlider = rootObj.value("MaxValueRSlider").toInt();
            if(CfgApp::instance()->m_nMaxValueRSlider == 0)
                CfgApp::instance()->m_nMaxValueRSlider = 1;

            CfgApp::instance()->m_nValueSlider = rootObj.value("ValueSlider").toInt();
            if(CfgApp::instance()->m_nValueSlider == 0)
                CfgApp::instance()->m_nValueSlider = 1;

            CfgApp::instance()->m_bIsOnAllOverLay	= rootObj.value("IsOnAllOverLay").toBool();
            CfgApp::instance()->m_bIsOnDefect		= rootObj.value("IsOnDefect").toBool();
            CfgApp::instance()->m_bIsOnOverKill		= rootObj.value("IsOnOverKill").toBool();
            CfgApp::instance()->m_bIsOnTracking		= rootObj.value("IsOnTracking").toBool();
            CfgApp::instance()->m_sTomOCamFocus		= rootObj.value("TomOCamFocus").toString();
            CfgApp::instance()->m_sOptispecCamFocus = rootObj.value("OptispecCamFocus").toString();
            CfgApp::instance()->m_sBomCamFocus		= rootObj.value("BomCamFocus").toString();
            CfgApp::instance()->m_sHeadCamFocus		= rootObj.value("HeadCamFocus").toString();
            CfgApp::instance()->m_bIsMaxTomOCam		= rootObj.value("IsMaxTomOCam").toBool();
            CfgApp::instance()->m_bIsMaxOptispecCam = rootObj.value("IsMaxOptispecCam").toBool();
            CfgApp::instance()->m_bIsMaxBomCam		= rootObj.value("IsMaxBomCam").toBool();
            CfgApp::instance()->m_bIsMaxHeadCam		= rootObj.value("IsMaxHeadCam").toBool();
            CfgApp::instance()->m_sBgColorCmd		= rootObj.value("BgColorCmd").toString();
            if(CfgApp::instance()->m_sBgColorCmd == "")
                CfgApp::instance()->m_sBgColorCmd = "#000000";
            CfgApp::instance()->m_sTextFontCmd = rootObj.value("TextFontCmd").toString();
            if(CfgApp::instance()->m_sTextFontCmd == "")
                CfgApp::instance()->m_sTextFontCmd = "Adobe Gothic Std B";
            CfgApp::instance()->m_nTextSizeCmd = rootObj.value("TextSizeCmd").toInt();
            if(CfgApp::instance()->m_nTextSizeCmd == 0)
                CfgApp::instance()->m_nTextSizeCmd = 9;
            CfgApp::instance()->m_sTextColorCmd = rootObj.value("TextColorCmd").toString();
            if(CfgApp::instance()->m_sTextColorCmd == "")
                CfgApp::instance()->m_sTextColorCmd = "#FFFFFF";
            CfgApp::instance()->m_nLineSpacingCmd = rootObj.value("LineSpacingCmd").toInt();
            if(CfgApp::instance()->m_nLineSpacingCmd == 0)
                CfgApp::instance()->m_nLineSpacingCmd = 2;

            CfgApp::instance()->m_bDisplayPanelStatus = rootObj.value("DisplayPanelStatus").toBool();
            CfgApp::instance()->m_bMotionPanelStatus  = rootObj.value("MotionPanelStatus").toBool();
            CfgApp::instance()->m_nHeightOfSystemlog  = rootObj.value("HeightOfSystemlog").toInt();
            CfgApp::instance()->m_nYOfSystemlog		  = rootObj.value("YOfSystemlog").toInt();
            CfgApp::instance()->m_nTabOfSystemlog	  = rootObj.value("TabOfSystemlog ").toInt();
            CfgApp::instance()->m_bIsTomOC			  = rootObj.value("IsTomOC").toBool();
        }
    }
    catch(const std::exception& e) {
        qDebug() << "Error when read file application config" << QString::fromStdString(e.what());
    }
}

void MasterApp::setAfterUiCreated()
{
    Q_EMIT initAllOverlayBtn(CfgApp::instance()->m_bIsOnAllOverLay);
    Q_EMIT initDefectBtn(CfgApp::instance()->m_bIsOnDefect);
    Q_EMIT initOverKillBtn(CfgApp::instance()->m_bIsOnOverKill);
    Q_EMIT initTrackingBtn(CfgApp::instance()->m_bIsOnTracking);
}

void MasterApp::writeFileConfig()
{
    //    QMutexLocker locker(&mutex);
    QJsonObject rootObj;
    rootObj.insert("ServerName", QString::fromStdString(CfgApp::instance()->m_strServerName));
    rootObj.insert("Port", CfgApp::instance()->m_nPort);
    rootObj.insert("VideoFolderPath", CfgApp::instance()->m_sVideoFolderPath);
    rootObj.insert("ProcessingTomoImagingSignalFrequencyMs", CfgApp::instance()->m_nProcessingTomoImagingSignalFrequencyMs);
    rootObj.insert("ConfigPath", CfgApp::instance()->m_sConfigPath);
    rootObj.insert("StreamingLenght", CfgApp::instance()->m_nStreamingLenght);
    rootObj.insert("MinValueRSlider", CfgApp::instance()->m_nMinValueRSlider);
    rootObj.insert("MaxValueRSlider", CfgApp::instance()->m_nMaxValueRSlider);
    rootObj.insert("ValueSlider", CfgApp::instance()->m_nValueSlider);
    rootObj.insert("IsOnAllOverLay", CfgApp::instance()->m_bIsOnAllOverLay);
    rootObj.insert("IsOnDefect", CfgApp::instance()->m_bIsOnDefect);
    rootObj.insert("IsOnOverKill", CfgApp::instance()->m_bIsOnOverKill);
    rootObj.insert("IsOnTracking", CfgApp::instance()->m_bIsOnTracking);
    rootObj.insert("TomOCamFocus", CfgApp::instance()->m_sTomOCamFocus);
    rootObj.insert("OptispecCamFocus", CfgApp::instance()->m_sOptispecCamFocus);
    rootObj.insert("BomCamFocus", CfgApp::instance()->m_sBomCamFocus);
    rootObj.insert("HeadCamFocus", CfgApp::instance()->m_sHeadCamFocus);
    rootObj.insert("IsMaxTomOCam", CfgApp::instance()->m_bIsMaxTomOCam);
    rootObj.insert("IsMaxOptispecCam", CfgApp::instance()->m_bIsMaxOptispecCam);
    rootObj.insert("IsMaxBomCam", CfgApp::instance()->m_bIsMaxBomCam);
    rootObj.insert("IsMaxHeadCam", CfgApp::instance()->m_bIsMaxHeadCam);
    rootObj.insert("BgColorCmd", CfgApp::instance()->m_sBgColorCmd);
    rootObj.insert("TextFontCmd", CfgApp::instance()->m_sTextFontCmd);
    rootObj.insert("TextSizeCmd", CfgApp::instance()->m_nTextSizeCmd);
    rootObj.insert("TextColorCmd", CfgApp::instance()->m_sTextColorCmd);
    rootObj.insert("LineSpacingCmd", CfgApp::instance()->m_nLineSpacingCmd);
    rootObj.insert("DisplayPanelStatus", CfgApp::instance()->m_bDisplayPanelStatus);
    rootObj.insert("MotionPanelStatus", CfgApp::instance()->m_bMotionPanelStatus);
    rootObj.insert("HeightOfSystemlog", CfgApp::instance()->m_nHeightOfSystemlog);
    rootObj.insert("YOfSystemlog", CfgApp::instance()->m_nYOfSystemlog);
    rootObj.insert("TabOfSystemlog", CfgApp::instance()->m_nTabOfSystemlog);
    rootObj.insert("IsTomOC", CfgApp::instance()->m_bIsTomOC);

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
