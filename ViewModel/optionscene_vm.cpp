#include "optionscene_vm.h"

OptionScene_VM::OptionScene_VM(MasterApp* masterApp, QObject* parent) : master_app{masterApp}, QObject(parent)
{

}

OptionScene_VM::~OptionScene_VM()
{

}
void OptionScene_VM::setResolution(int width, int height){
    master_app->config.m_ScreenWidth=width;
    master_app->config.m_ScreenHeight=height;
    master_app->config.writeFileConfig();
}
