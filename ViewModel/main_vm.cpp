#include "main_vm.h"
#include <QDebug>


MainVM::MainVM(QApplication* app, int argc, char** argv, QObject* parent) : QObject(parent)
{
    master_app.reset(new MasterApp(parent));
}

MainVM::~MainVM()
{
    delete master_app.data();
}

