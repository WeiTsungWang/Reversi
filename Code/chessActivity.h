#include<QQmlApplicationEngine>
#include <QObject>
#include<QString>
#include<QColor>
#include<QList>
#include<vector>
#include<set>
#include"chess.h"

using namespace std;

#ifndef CHESSACTIVITY_H
#define CHESSACTIVITY_H

class ChessActivity : public QObject {
    Q_OBJECT

    Q_PROPERTY(QList<QObject*>pieces READ getPiece NOTIFY boardChanged);
    Q_PROPERTY(QObject* round READ getRound NOTIFY roundChanged);
    Q_PROPERTY(bool undoEnable READ getUndoEnable WRITE setUndoEnable NOTIFY undoEnableChanged);
    Q_PROPERTY(bool nextStepEnable READ getNextStepEnable WRITE setNextStepEnable NOTIFY nextStepEnableChanged);
    Q_PROPERTY(QString endMessage READ getEndMessage WRITE setEndMessage NOTIFY endMessageChanged );
    Q_PROPERTY(int time READ getTime WRITE setTime NOTIFY timeChanged);
    Q_PROPERTY(bool isTimerActive READ getIsTimerActive WRITE setIsTimerActive NOTIFY isTimerActiveChanged);
    Q_PROPERTY(int blackCount READ getBlackCount WRITE setBlackCount NOTIFY blackCountChanged);
    Q_PROPERTY(int whiteCount READ getWhiteCount WRITE setWhiteCount NOTIFY whiteCountChanged);
    Q_PROPERTY(QStringList  files READ getFiles WRITE setFiles NOTIFY filesChanged FINAL);

public:
    ChessActivity(QObject *parent = nullptr);

    QList<QObject*> getPiece();

    vector<int> getList(pair<int,int> direct,int posY,int posX);
    void findEnable(pair<int,int> direct,int posY,int posX);
    void findcandidate(pair<int,int> direct,int posY,int posX);
    void updateBoard();
    Q_INVOKABLE void move(int index);

    void setUndoEnable(bool _bool);
    void setNextStepEnable(bool _bool);
    bool getUndoEnable();
    bool getNextStepEnable();
    void pushRecord();
    Q_INVOKABLE void undo();
    Q_INVOKABLE void nextStep();
    void judgeIsEnableUndoOrNextStep();

    void ending();
    void setEndMessage(QString result);
    QString getEndMessage();

    Q_INVOKABLE void reset();

    Q_INVOKABLE void cycle(int mode);// 0:next 1:auto
    QObject* getRound();
    int getTime();
    void setTime(int _time);
    bool getIsTimerActive();
    void setIsTimerActive(bool _isActive);

    void autoMove();
    Q_INVOKABLE void settingReading(int _isAutoMoveActivity,int _autoMoveTurn,bool _isTimerAvailable,int _setDuration);//If AI is disable _isAutoMoveActivity and _autoMoveTurn must be 0.

    int getBlackCount();
    void setBlackCount(int _blackCount);
    int getWhiteCount();
    void setWhiteCount(int _WhiteCount);
    void calculatePieces();

    QStringList  getFiles();
    void setFiles(QStringList  _input);

    Q_INVOKABLE void saveFile(bool isReadonly,QString fileName);
    Q_INVOKABLE void loadExistFile(bool isReadonly);
    Q_INVOKABLE void loadNormalFile(QString fileName);
    Q_INVOKABLE void loadReadonlyFile(QString fileName);
    Q_INVOKABLE void reviewNextStep();
    Q_INVOKABLE void reviewLastStep();
    Q_INVOKABLE void showConvertable(int index);
    Q_INVOKABLE void hideConvertable();

private:
    int board[8][8];
    int turnFlag;
    set<pair<int,int>> candidate;
    set<pair<int,int>> enable;
    QList<QObject*> pieces;

    vector<vector<vector<int>>> record;
    vector<set<pair<int,int>>> candidateRecord;
    vector<int>pastRound;
    bool undoEnable,nextStepEnable;
    int recordPointer;

    QString endMessage;

    int blackCount;
    int whiteCount;

    int timer;
    QObject* round;
    ChessType roundType;

    int setDuration;
    bool isTimerAvailable;
    int autoMoveTurn;
    int isAutoMoveActivity;

    QStringList  loadedFilesName;

    bool changeable;


signals:
    void boardChanged();
    void undoEnableChanged();
    void nextStepEnableChanged();
    void showEndDialog();
    void endMessageChanged();
    void roundChanged();
    void timeChanged();
    void isTimerActiveChanged();
    void timerRunning();
    void blackCountChanged();
    void whiteCountChanged();
    void filesChanged();
    void flip(int sentIndex);
};

#endif // CHESSACTIVITY_H
