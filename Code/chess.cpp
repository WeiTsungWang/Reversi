#include<QQmlApplicationEngine>
#include <QObject>
#include"chess.h"

using namespace std;

ChessType::ChessType(int _row,int _col){
    type=0;
    row=_row;
    col=_col;
    ChangeAttribute();
}

ChessType::ChessType(int _type,int _row,int _col){
    type=_type;
    row=_row;
    col=_col;
    ChangeAttribute();
}

void ChessType::ChangeType(int _type){
    type=_type;
    ChangeAttribute();
}

void ChessType::ChangeAttribute(){
    if(type==1){
        setChessColor("black");
        setBorderColor("black");
        setBorderWidth(0);
        setIsVisable(true);
        setIsAvailable(false);
    }
    else if(type==-1){
        setChessColor("white");
        setBorderColor("white");
        setBorderWidth(0);
        setIsVisable(true);
        setIsAvailable(false);
    }
    else if(type==2){
        setChessColor("green");
        setBorderColor("yellow");
        setBorderWidth(1);
        setIsVisable(true);
        setIsAvailable(true);
    }
    else{
        setChessColor("green");
        setBorderColor("blue");
        setBorderWidth(0);
        setIsVisable(false);
        setIsAvailable(false);
    }
}



void ChessType::setChessColor(QColor _color){
    chessColor=_color;
    emit chessColorChanged();
}
void ChessType::setBorderColor(QColor _color){
    borderColor=_color;
    emit borderColorChanged();
}
void ChessType::setBorderWidth(int _width){
    borderWidth=_width;
    emit borderWidthChanged();
}
void ChessType::setIsAvailable(bool _bool){
    isAvailable=_bool;
    emit isAvailableChanged();
}
void ChessType::setIsVisable(bool _bool){
    isVisable=_bool;
    emit isVisableChanged();
}
void ChessType::setChangeable(bool _bool){
    changeable=_bool;
    emit changeableChange();
}

int ChessType::getBorderWidth(){
    return borderWidth;
}
QColor ChessType::getChessColor(){
    return chessColor;
}
QColor ChessType::getBorderColor(){
    return borderColor;
}
bool ChessType::getIsAvailable(){
    return isAvailable;
}
bool ChessType::getIsVisable(){
    return isVisable;
}
bool ChessType::getChangeable(){
    return changeable;
}
