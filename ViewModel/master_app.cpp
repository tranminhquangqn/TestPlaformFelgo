#include "master_app.h"

MasterApp::MasterApp(QObject* parent): QObject{parent}
{
    config.readFileConfig();
    initApp();

}

MasterApp::~MasterApp()
{

}
void MasterApp::initApp()
{
}
