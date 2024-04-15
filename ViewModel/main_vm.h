#ifndef MAIN_VM_H
#define MAIN_VM_H

#include <QApplication>
#include <QObject>
#include <QSharedPointer>

#include "master_app.h"
#include "optionscene_vm.h"
#include "gameprogress_vm.h"
class MainVM: public QObject
{
    Q_OBJECT
public:
    MainVM(QApplication* app, int argc, char** argv, QObject* parent = nullptr);
    ~MainVM();
    QSharedPointer<MasterApp> master_app;
    QScopedPointer<GameProgress> gameProgressVM;
    QScopedPointer<OptionScene_VM> optionsceneVM;

public slots:
};
#endif // MAIN_VM_H
