#ifndef MAIN_VM_H
#define MAIN_VM_H

#include <QApplication>
#include <QObject>
#include <QSharedPointer>

class MainVM: public QObject
{
    Q_OBJECT
public:
    MainVM(QApplication* qapp, int argc, char** argv, QObject* parent = nullptr);

public slots:
    void buttonCClicked();
};
#endif // MAIN_VM_H
