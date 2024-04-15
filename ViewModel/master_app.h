#ifndef MASTER_APP_H
#define MASTER_APP_H

#include <QObject>
#include <QSharedPointer>
#include "../ScriptConfig/cfg_app.h"
class MasterApp : public QObject
{
    Q_OBJECT

public:
    MasterApp(QObject* parent = nullptr);
    ~MasterApp();

    CfgApp config;
    QScopedPointer<CfgApp> cfgApp;
    void initApp();
};

#endif // MASTER_APP_H
