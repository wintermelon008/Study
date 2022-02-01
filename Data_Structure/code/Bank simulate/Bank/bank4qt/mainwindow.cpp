#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "string.h"
#include "queue.h"
#include "defines.h"
#include <math.h>
#include <cstdlib>

extern int mainfunction();
extern int CustomerNum;
extern int TotalTime;
extern int maxIntervaltime;			//最长到达事件间隔时间， 用于下一用户到达事件的随机数生成
extern int maxCustomermoney;				//客户操作的最大金额
extern int maxCustomertime;				//最长客户操作时间
extern unsigned int seed;

MainWindow::MainWindow(QWidget *parent)
    : QMainWindow(parent)
    , ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}


void MainWindow::on_startBut_clicked()
{
    mainfunction();
    ui->output_ave->setText(QString::number(fabs(1.0*TotalTime / CustomerNum)));
    ui->output_num->setText(QString::number(abs(CustomerNum)));

}


void MainWindow::on_bm_T_textChanged(const QString &arg1)
{
    bankmoney = arg1.toInt();
}


void MainWindow::on_ct_T_textChanged(const QString &arg1)
{
    closetime = arg1.toInt();
}


void MainWindow::on_qAn_T_textChanged(const QString &arg1)
{
    QueANum = arg1.toInt();
}


void MainWindow::on_mx_i_T_textChanged(const QString &arg1)
{
    maxIntervaltime = arg1.toInt();
}


void MainWindow::on_mx_d_T_textChanged(const QString &arg1)
{
    maxCustomertime = arg1.toInt();
}


void MainWindow::on_mx_m_T_textChanged(const QString &arg1)
{
    maxCustomermoney = arg1.toInt();
}



void MainWindow::on_random_but_clicked()
{
    unsigned int sseed = (unsigned int)time(0);
    seed = rand() % sseed;
    ui->seed->setText(QString::number(seed));
    mainfunction();
    ui->output_ave->setText(QString::number(fabs(1.0*TotalTime / CustomerNum)));
    ui->output_num->setText(QString::number(abs(CustomerNum)));
}

