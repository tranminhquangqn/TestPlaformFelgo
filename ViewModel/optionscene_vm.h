#ifndef OPTIONSCENE_VM_H
#define OPTIONSCENE_VM_H

#include <QObject>
#include "master_app.h"
class OptionScene_VM: public QObject
{
    Q_OBJECT
public:
    explicit OptionScene_VM(MasterApp* masterApp, QObject* parent = nullptr);
    ~OptionScene_VM();
private:
    MasterApp* master_app;
Q_SIGNALS:
//	void sendCurrentValueSlider(double);
public Q_SLOTS:
    void setResolution(int, int);

};

#endif // OPTIONSCENE_VM_H
