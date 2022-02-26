#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>

QT_BEGIN_NAMESPACE
namespace Ui { class MainWindow; }
QT_END_NAMESPACE

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_startBut_clicked();

    void on_bm_T_textChanged(const QString &arg1);

    void on_ct_T_textChanged(const QString &arg1);

    void on_qAn_T_textChanged(const QString &arg1);

    void on_mx_i_T_textChanged(const QString &arg1);

    void on_mx_d_T_textChanged(const QString &arg1);

    void on_mx_m_T_textChanged(const QString &arg1);

    void on_random_but_clicked();


private:
    Ui::MainWindow *ui;
};
#endif // MAINWINDOW_H
