#include<QQmlApplicationEngine>
#include <QObject>
#include<QString>
#include<QColor>

using namespace std;

#ifndef CHESSTYPE_H
#define CHESSTYPE_H

class ChessType : public QObject {
    Q_OBJECT

    Q_PROPERTY(int borderWidth READ getBorderWidth WRITE setBorderWidth NOTIFY borderWidthChanged)
    Q_PROPERTY(QColor chessColor READ getChessColor WRITE setChessColor NOTIFY chessColorChanged)
    Q_PROPERTY(QColor borderColor READ getBorderColor WRITE setBorderColor NOTIFY borderColorChanged)
    Q_PROPERTY(bool isAvailable READ getIsAvailable WRITE setIsAvailable NOTIFY isAvailableChanged)
    Q_PROPERTY(bool isVisable READ getIsVisable WRITE setIsVisable NOTIFY isVisableChanged)
    Q_PROPERTY(bool changeable READ getChangeable WRITE setChangeable NOTIFY changeableChange);


private:
    int type;//0:null 1:black -1:white 2:enable
    QColor chessColor;
    QColor borderColor;
    bool isVisable;
    bool isAvailable;
    int borderWidth;
    int row,col;
    bool changeable;

public:
    ChessType(int _row,int _col);
    ChessType(int _type,int _row,int _col);

    void ChangeType(int _type);

    void ChangeAttribute();

    void setBorderWidth(int _width);
    void setChessColor(QColor _color);
    void setBorderColor(QColor _color);
    void setIsAvailable(bool _bool);
    void setIsVisable(bool _bool);
    void setChangeable(bool _bool);

    int getBorderWidth();
    QColor getChessColor();
    QColor getBorderColor();
    bool getIsAvailable();
    bool getIsVisable();
    bool getChangeable();

signals:
    void borderWidthChanged();
    void chessColorChanged();
    void borderColorChanged();
    void isAvailableChanged();
    void isVisableChanged();
    void changeableChange();
};


#endif // CHESSTYPE_H
