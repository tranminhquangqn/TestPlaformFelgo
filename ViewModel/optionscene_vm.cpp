#include "optionscene_vm.h"

OptionScene_VM::OptionScene_VM(MasterApp* master_app, QObject* parent) : master_app(master_app), QObject{parent}
{

}

OptionScene_VM::~OptionScene_VM()
{

}
void OptionScene_VM::setResolution(int width, int height){
    master_app->config.setScreenWidth(width);
    master_app->config.setScreenHeight(height);
    master_app->config.writeFileConfig();
}
