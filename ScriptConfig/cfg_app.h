#ifndef CFGAPP_H
#define CFGAPP_H

// My include
#include <vector>
#include <fstream>
#include <QStandardPaths>
#include <QDir>
//#include "../Define/struct_def.h"
// end

using namespace std;

class CfgApp
{
public:
    CfgApp();
    ~CfgApp();

    static CfgApp* instance();

//	StateBackupProcess stateBackupProcess;
    void readFileConfig();
    void writeFileConfig();


//	QVector<QString> trackNames;
//	QHash<QString, QStringList> docNames;
//	int getCameraFocusFromString(std::string);
//	int convertAccessLevel(std::string);
//	// for focus tab view and ,maximize
//	//Not show in UI
//	std::vector<std::string> camsFocus		  = {"Tomo Pose", "Tomo", "Shipper", "Carton Transfer"};

    QString m_strServerName;
    QString m_sConfigPath=QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    int m_nPort;
    bool m_bIsOnAllOverLay;


//	std::vector<std::string> camerasID		  = {"18443010611D631200", "184430108165940F00", "1844301041F6621200"};
//	std::vector<std::string> defaultCamerasID		  = {"18443010611D631200", "184430108165940F00", "1844301041F6621200"};
//	/*---------------------------*/

//	bool configValid = true;

protected:
   // string fileConfig = getenv("HOME") + std::string("/tomo_config/carton_ui.yaml");
    QString  fileConfig = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/ALOALO.json";
};

#endif	// CFGAPP_H
