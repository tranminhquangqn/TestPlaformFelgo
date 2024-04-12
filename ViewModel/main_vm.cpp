#include "main_vm.h"
#include <QDebug>


MainVM::MainVM(QApplication* app, int argc, char** argv, QObject* parent) : QObject(parent)
{
    master_app.reset(new MasterApp(parent));
//    optionsceneVM.reset(new OptionScene_VM(master_app.data(), parent));
}

MainVM::~MainVM()
{
    delete master_app.data();
}

