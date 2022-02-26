/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created by: Qt User Interface Compiler version 6.2.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtWidgets/QApplication>
#include <QtWidgets/QFrame>
#include <QtWidgets/QLabel>
#include <QtWidgets/QMainWindow>
#include <QtWidgets/QMenuBar>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpinBox>
#include <QtWidgets/QStatusBar>
#include <QtWidgets/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralwidget;
    QLabel *default_setting;
    QLabel *bm_L;
    QLabel *cl_L;
    QLabel *qAn_L;
    QLabel *mx_i_L;
    QLabel *mx_d_L;
    QLabel *mx_m_L;
    QSpinBox *qAn_T;
    QSpinBox *bm_T;
    QSpinBox *ct_T;
    QSpinBox *mx_i_T;
    QSpinBox *mx_d_T;
    QSpinBox *mx_m_T;
    QPushButton *startBut;
    QFrame *line;
    QLabel *output_ave;
    QLabel *output_ave_L;
    QFrame *line_2;
    QFrame *line_3;
    QLabel *output_num_L;
    QLabel *output_num;
    QLabel *seed_l;
    QPushButton *random_but;
    QLabel *seed;
    QMenuBar *menubar;
    QStatusBar *statusbar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(800, 600);
        centralwidget = new QWidget(MainWindow);
        centralwidget->setObjectName(QString::fromUtf8("centralwidget"));
        default_setting = new QLabel(centralwidget);
        default_setting->setObjectName(QString::fromUtf8("default_setting"));
        default_setting->setGeometry(QRect(50, 20, 81, 20));
        bm_L = new QLabel(centralwidget);
        bm_L->setObjectName(QString::fromUtf8("bm_L"));
        bm_L->setGeometry(QRect(10, 60, 81, 16));
        cl_L = new QLabel(centralwidget);
        cl_L->setObjectName(QString::fromUtf8("cl_L"));
        cl_L->setGeometry(QRect(10, 100, 81, 16));
        qAn_L = new QLabel(centralwidget);
        qAn_L->setObjectName(QString::fromUtf8("qAn_L"));
        qAn_L->setGeometry(QRect(10, 140, 91, 16));
        mx_i_L = new QLabel(centralwidget);
        mx_i_L->setObjectName(QString::fromUtf8("mx_i_L"));
        mx_i_L->setGeometry(QRect(10, 180, 91, 16));
        mx_d_L = new QLabel(centralwidget);
        mx_d_L->setObjectName(QString::fromUtf8("mx_d_L"));
        mx_d_L->setGeometry(QRect(10, 220, 91, 16));
        mx_m_L = new QLabel(centralwidget);
        mx_m_L->setObjectName(QString::fromUtf8("mx_m_L"));
        mx_m_L->setGeometry(QRect(10, 260, 91, 16));
        qAn_T = new QSpinBox(centralwidget);
        qAn_T->setObjectName(QString::fromUtf8("qAn_T"));
        qAn_T->setGeometry(QRect(100, 140, 51, 21));
        qAn_T->setMinimum(1);
        bm_T = new QSpinBox(centralwidget);
        bm_T->setObjectName(QString::fromUtf8("bm_T"));
        bm_T->setGeometry(QRect(100, 60, 51, 21));
        bm_T->setMinimum(0);
        bm_T->setMaximum(1000000);
        bm_T->setValue(1000);
        ct_T = new QSpinBox(centralwidget);
        ct_T->setObjectName(QString::fromUtf8("ct_T"));
        ct_T->setGeometry(QRect(100, 100, 51, 21));
        ct_T->setMinimum(5);
        ct_T->setMaximum(10000);
        ct_T->setValue(100);
        mx_i_T = new QSpinBox(centralwidget);
        mx_i_T->setObjectName(QString::fromUtf8("mx_i_T"));
        mx_i_T->setGeometry(QRect(100, 180, 51, 21));
        mx_i_T->setMinimum(5);
        mx_i_T->setMaximum(1000);
        mx_i_T->setValue(30);
        mx_d_T = new QSpinBox(centralwidget);
        mx_d_T->setObjectName(QString::fromUtf8("mx_d_T"));
        mx_d_T->setGeometry(QRect(100, 220, 51, 21));
        mx_d_T->setMinimum(5);
        mx_d_T->setMaximum(1000);
        mx_d_T->setValue(30);
        mx_m_T = new QSpinBox(centralwidget);
        mx_m_T->setObjectName(QString::fromUtf8("mx_m_T"));
        mx_m_T->setGeometry(QRect(100, 260, 51, 21));
        mx_m_T->setMinimum(1);
        mx_m_T->setMaximum(1000000);
        mx_m_T->setValue(1000);
        startBut = new QPushButton(centralwidget);
        startBut->setObjectName(QString::fromUtf8("startBut"));
        startBut->setGeometry(QRect(100, 380, 71, 31));
        line = new QFrame(centralwidget);
        line->setObjectName(QString::fromUtf8("line"));
        line->setGeometry(QRect(170, 10, 21, 551));
        line->setFrameShape(QFrame::VLine);
        line->setFrameShadow(QFrame::Sunken);
        output_ave = new QLabel(centralwidget);
        output_ave->setObjectName(QString::fromUtf8("output_ave"));
        output_ave->setGeometry(QRect(90, 470, 71, 21));
        output_ave->setFrameShape(QFrame::Box);
        output_ave_L = new QLabel(centralwidget);
        output_ave_L->setObjectName(QString::fromUtf8("output_ave_L"));
        output_ave_L->setGeometry(QRect(20, 470, 51, 21));
        line_2 = new QFrame(centralwidget);
        line_2->setObjectName(QString::fromUtf8("line_2"));
        line_2->setGeometry(QRect(0, 290, 181, 16));
        line_2->setFrameShape(QFrame::HLine);
        line_2->setFrameShadow(QFrame::Sunken);
        line_3 = new QFrame(centralwidget);
        line_3->setObjectName(QString::fromUtf8("line_3"));
        line_3->setGeometry(QRect(0, 440, 181, 16));
        line_3->setFrameShape(QFrame::HLine);
        line_3->setFrameShadow(QFrame::Sunken);
        output_num_L = new QLabel(centralwidget);
        output_num_L->setObjectName(QString::fromUtf8("output_num_L"));
        output_num_L->setGeometry(QRect(20, 510, 51, 21));
        output_num = new QLabel(centralwidget);
        output_num->setObjectName(QString::fromUtf8("output_num"));
        output_num->setGeometry(QRect(90, 510, 71, 21));
        output_num->setFrameShape(QFrame::Box);
        seed_l = new QLabel(centralwidget);
        seed_l->setObjectName(QString::fromUtf8("seed_l"));
        seed_l->setGeometry(QRect(30, 330, 71, 21));
        random_but = new QPushButton(centralwidget);
        random_but->setObjectName(QString::fromUtf8("random_but"));
        random_but->setGeometry(QRect(100, 330, 71, 31));
        seed = new QLabel(centralwidget);
        seed->setObjectName(QString::fromUtf8("seed"));
        seed->setGeometry(QRect(10, 360, 71, 31));
        seed->setFrameShape(QFrame::Box);
        MainWindow->setCentralWidget(centralwidget);
        menubar = new QMenuBar(MainWindow);
        menubar->setObjectName(QString::fromUtf8("menubar"));
        menubar->setGeometry(QRect(0, 0, 800, 21));
        MainWindow->setMenuBar(menubar);
        statusbar = new QStatusBar(MainWindow);
        statusbar->setObjectName(QString::fromUtf8("statusbar"));
        MainWindow->setStatusBar(statusbar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QCoreApplication::translate("MainWindow", "Bank", nullptr));
        default_setting->setText(QCoreApplication::translate("MainWindow", "\345\210\235\345\247\213\346\235\241\344\273\266\350\256\276\347\275\256", nullptr));
        bm_L->setText(QCoreApplication::translate("MainWindow", "\351\223\266\350\241\214\345\210\235\345\247\213\351\207\221\351\242\235", nullptr));
        cl_L->setText(QCoreApplication::translate("MainWindow", "\351\223\266\350\241\214\345\205\263\351\227\250\346\227\266\351\227\264", nullptr));
        qAn_L->setText(QCoreApplication::translate("MainWindow", "\347\254\254\344\270\200\347\261\273\351\230\237\345\210\227\346\225\260\351\207\217", nullptr));
        mx_i_L->setText(QCoreApplication::translate("MainWindow", "\346\234\200\351\225\277\345\210\260\350\276\276\351\227\264\351\232\224", nullptr));
        mx_d_L->setText(QCoreApplication::translate("MainWindow", "\346\234\200\351\225\277\344\270\232\345\212\241\346\227\266\351\227\264", nullptr));
        mx_m_L->setText(QCoreApplication::translate("MainWindow", "\346\234\200\345\244\247\346\223\215\344\275\234\351\207\221\351\242\235", nullptr));
        startBut->setText(QCoreApplication::translate("MainWindow", "\345\206\215\346\254\241\346\250\241\346\213\237", nullptr));
        output_ave->setText(QString());
        output_ave_L->setText(QCoreApplication::translate("MainWindow", "\345\271\263\345\235\207\346\227\266\351\227\264", nullptr));
        output_num_L->setText(QCoreApplication::translate("MainWindow", "\346\234\211\346\225\210\344\272\272\346\225\260", nullptr));
        output_num->setText(QString());
        seed_l->setText(QCoreApplication::translate("MainWindow", "\347\247\215\345\255\220\347\240\201", nullptr));
        random_but->setText(QCoreApplication::translate("MainWindow", "\346\226\260\347\232\204\346\250\241\346\213\237", nullptr));
        seed->setText(QString());
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
