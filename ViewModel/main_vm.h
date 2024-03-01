#ifndef MAIN_VM_H
#define MAIN_VM_H

#include <QApplication>
#include <QObject>
#include <QSharedPointer>

#include "master_app.h"
class MainVM: public QObject
{
    Q_OBJECT
public:
    MainVM(QApplication* app, int argc, char** argv, QObject* parent = nullptr);
    ~MainVM();
    QSharedPointer<MasterApp> master_app;
public slots:
    void buttonCClicked();
};
#endif // MAIN_VM_H
