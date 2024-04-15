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
    Q_PROPERTY(int screenWidth READ screenWidth WRITE setScreenWidth)
    Q_PROPERTY(int screenHeight READ screenHeight WRITE setScreenHeight)
    Q_PROPERTY(int generalVolume READ generalVolume WRITE setGeneralVolume)
    Q_PROPERTY(bool isFullScreen READ isFullScreen WRITE setIsFullScreen)
    static CfgApp* instance();

    void readFileConfig();
    void writeFileConfig();

//    QString m_saveName;

    int m_ScreenWidth;
    int m_ScreenHeight;
    int m_GeneralVolume;
    bool m_isFullScreen;
Q_SIGNALS:
public Q_SLOTS:
    void setScreenWidth(int value);
    int screenWidth();
    void setScreenHeight(int value);
    int screenHeight();
    void setGeneralVolume(int value);
    int generalVolume();
    void setIsFullScreen(bool value);
    int isFullScreen();

protected:
    QString m_sConfigPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);
    QString fileConfig    = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation)+"/ALOALO.json";
};

#endif	// CFGAPP_H
