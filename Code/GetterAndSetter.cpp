#include <QQmlApplicationEngine>
#include <QObject>
#include <QString>
#include <cstdlib>
#include <ctime>
#include "chessActivity.h"

using namespace std;

QList<QObject*> ChessActivity::getPiece(){
    return pieces;
}

void ChessActivity::setUndoEnable(bool _bool){
    undoEnable=_bool;
    emit undoEnableChanged();
}

void ChessActivity::setNextStepEnable(bool _bool){
    nextStepEnable=_bool;
    emit nextStepEnableChanged();
}

bool ChessActivity::getUndoEnable(){
    return undoEnable;
}

bool ChessActivity::getNextStepEnable(){
    return nextStepEnable;
}

QString ChessActivity::getEndMessage(){
    return endMessage;
}

void ChessActivity::setEndMessage(QString result){
    endMessage=result;
    emit endMessageChanged();
}

QObject* ChessActivity::getRound(){
    return round;
};

int ChessActivity::getTime(){
    return timer;
}

void ChessActivity::setTime(int _time){
    timer=_time;
    emit timeChanged();
}

bool ChessActivity::getIsTimerActive(){
    return isTimerAvailable;
}
void ChessActivity::setIsTimerActive(bool _isActive){
    isTimerAvailable=_isActive;
    emit isTimerActiveChanged();
}

int ChessActivity::getBlackCount(){
    return blackCount;
}
void ChessActivity::setBlackCount(int _blackCount){
    blackCount=_blackCount;
    emit blackCountChanged();
}

int ChessActivity::getWhiteCount(){
    return whiteCount;
}
void ChessActivity::setWhiteCount(int _WhiteCount){
    whiteCount=_WhiteCount;
    emit whiteCountChanged();
}

QStringList  ChessActivity::getFiles(){
    return loadedFilesName;
}
void ChessActivity::setFiles(QStringList  _input){
    loadedFilesName=_input;
    emit filesChanged();
}
