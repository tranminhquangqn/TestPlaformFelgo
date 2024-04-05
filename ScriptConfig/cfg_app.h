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

    void readFileConfig();
    void writeFileConfig();


//	QVector<QString> trackNames;
//	QHash<QString, QStringList> docNames;
//	int getCameraFocusFromString(std::string);
//	int convertAccessLevel(std::string);
//	// for focus tab view and ,maximize
//	//Not show in UI
//	std::vector<std::string> camsFocus		  = {"Tomo Pose", "Tomo", "Shipper", "Carton Transfer"};

    QString m_saveName;
    QString m_sConfigPath=QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    int m_nPort;
    bool m_bIsOnAllOverLay;

protected:
    QString  fileConfig = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/ALOALO.json";
};

#endif	// CFGAPP_H
