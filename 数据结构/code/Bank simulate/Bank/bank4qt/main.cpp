#include "mainwindow.h"
#include "defines.h"
#include "queue.h"

#include <QApplication>

int maxIntervaltime = MAX_INTERVAL_TIME;
int maxCustomermoney = MAX_CUST_MONEY;
int maxCustomertime = MAX_CUST_DURTIME;
int bankmoney = INI_BANK_MONEY;
int closetime = CLOSE_TIME;
int QueANum = QUEUEA_NUM;
unsigned int seed = 0;   //随机数种子

int main(int argc, char *argv[])
{


    QApplication a(argc, argv);
    MainWindow w;
    w.show();
    return a.exec();
}
