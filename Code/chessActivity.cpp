#include <QQmlApplicationEngine>
#include <QObject>
#include <QString>
#include <vector>
#include <set>
#include <iostream>
#include <algorithm>
#include <cstdlib>
#include <ctime>
#include <fstream>
#include <sstream>
#include "chessActivity.h"
#include "chess.h"

using namespace std;

const vector<pair<int,int>> allDirect={{1,0},{-1,0},{0,1},{0,-1},{1,1},{1,-1},{-1,1},{-1,-1}};

ChessActivity::ChessActivity(QObject *parent):QObject(parent),roundType(1,0,0){
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            ChessType *regis;
            if((i == 3 && j == 3 )||(i == 4 && j == 4)){
                regis=new ChessType(-1,i,j);
                board[i][j]=-1;
            }
            else if((i == 3 && j == 4 )||(i == 4 && j == 3)){
                regis=new ChessType(1,i,j);
                board[i][j]=1;
            }
            else{
                regis=new ChessType(i,j);
                board[i][j]=0;
            }
            regis->setChangeable(false);
            pieces.append(regis);

            if(i==2&&(j>1&&j<6)){
                candidate.insert({i,j});
            }
            if(i==5&&(j>1&&j<6)){
                candidate.insert({i,j});
            }
            if(j==2&&(i>1&&i<6)){
                candidate.insert({i,j});
            }
            if(j==5&&(i>1&&i<6)){
                candidate.insert({i,j});
            }
        }
    }
    record.clear();
    candidateRecord.clear();
    pastRound.clear();
    recordPointer=-1;
    pushRecord();
    pastRound.push_back(turnFlag);

    for(auto i:enable){
        board[i.first][i.second]=2;
        auto obj = qobject_cast<ChessType*>(pieces.at(i.first*8+i.second));
        if (obj) {
            obj->ChangeType(2);
        }
    }

    roundType.ChangeType(1);
    round=dynamic_cast<QObject*>(&roundType);

    endMessage="";
    whiteCount=0;
    blackCount=0;

    timer=setDuration;
}

void ChessActivity::settingReading(int _isAutoMoveActivity,int _autoMoveTurn,bool _isTimerAvailable,int _setDuration){
    isAutoMoveActivity=_isAutoMoveActivity;
    autoMoveTurn=_autoMoveTurn;
    setIsTimerActive(_isTimerAvailable);
    setTime(_setDuration);
    setDuration=_setDuration;
}


vector<int> ChessActivity::getList(pair<int,int> direct,int posY,int posX) {
    int turn = 1;
    vector<int>list;

    while (posX + direct.second * turn >= 0 && posX + direct.second * turn < 8 && posY + direct.first * turn >= 0 && posY + direct.first * turn < 8) {
        if (board[posY + direct.first * turn][posX + direct.second * turn] == 0 || board[posY + direct.first * turn][posX + direct.second * turn] == 2) {
            break;
        }
        list.push_back(board[posY + direct.first * turn][posX + direct.second * turn]);
        turn++;
    }
    return list;
}

void ChessActivity::findEnable(pair<int,int> direct,int posY,int posX){
    vector<int> list = getList(direct,posY,posX);
    for (int i = 0; i < list.size(); i++) {
        if (i == 0 && list[i] == turnFlag) {
            return;
        }
        else if (list[i] == -turnFlag) {
            continue;
        }
        else {
            enable.insert(make_pair(posY, posX));
        }
    }
    return;
}

void ChessActivity::findcandidate(pair<int,int> direct,int posY,int posX){
    candidate.erase({posY, posX});
    if (posY + direct.second >= 0 && posY + direct.second < 8 && posX + direct.first >= 0 && posX + direct.first < 8) {
        if (board[posY + direct.second][posX + direct.first] == 0) {
            candidate.insert(make_pair(posY + direct.second, posX + direct.first));
        }
    }
}

Q_INVOKABLE void ChessActivity::move(int index){
    int endPoint = 0;
    int posY=index/8,posX=index%8;
    int endFlag=0; //if endFlag==3 end this game.
    board[posY][posX]=turnFlag;

    for(auto i:allDirect){
        vector<int> list = getList(i,posY,posX);
        for (int j = 0; j < list.size(); j++) {
            if (list[j] == turnFlag) {
                endPoint = j;
                break;
            }
        }
        for (int j = 0; j < endPoint; j++) {
            board[posY + i.first * (j + 1)][posX + i.second * (j + 1)]=turnFlag;
        }
        endPoint = 0;
    }

    for(int i=0;i<8;i++)
        for(int j=0;j<8;j++)
            if(board[i][j]==2)
                board[i][j]=0;


    for(auto i:allDirect){
        findcandidate(i,posY,posX);
    }

    int recordSize=record.size();
    for(int i=recordPointer+1;i<recordSize;i++){
        record.pop_back();
        candidateRecord.pop_back();
        pastRound.pop_back();
    }

    pushRecord();

    enable.clear();
    do{
        turnFlag = -turnFlag;
        for(auto i:candidate){
            for(auto j:allDirect){
                findEnable(j,i.first,i.second);
            }
        }
        for(auto i:enable){
            board[i.first][i.second]=2;
        }
        endFlag++;
        if(endFlag==3){
            break;
        }
    }while(enable.size()==0);

    pastRound.push_back(turnFlag);

    updateBoard();
    calculatePieces();

    judgeIsEnableUndoOrNextStep();

    if(endFlag==3){
        ending();
        return;
    }
    cycle(0);
    if(isAutoMoveActivity==1&&autoMoveTurn==turnFlag){
        cycle(1);
    }
}

void ChessActivity::updateBoard(){
    string color;
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            if(board[i][j]==1)
                color="#000000";
            else if(board[i][j]==-1)
                color="#ffffff";
            auto obj = qobject_cast<ChessType*>(pieces.at(i*8+j));
            if (obj) {
                if(obj->getChessColor().name().toStdString()!=color && obj->getChessColor().name().toStdString()!="#008000" && board[i][j]!=2){
                    emit flip(i*8+j);
                }


                obj->ChangeType(board[i][j]);
            }
        }
    }
    // emit boardChanged();
}


//undo part

void ChessActivity::pushRecord(){
    vector<vector<int>> regisBoard;
    vector<int> regisRow;
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            regisRow.push_back(board[i][j]);
        }
        regisBoard.push_back(regisRow);
        regisRow.clear();
    }
    record.push_back(regisBoard);
    candidateRecord.push_back(candidate);
    recordPointer++;
    judgeIsEnableUndoOrNextStep();
}

void ChessActivity::undo(){
    int endFlag=0;
    if(isAutoMoveActivity==0){
        recordPointer--;
    }else{
        for(int i=recordPointer-1;i>=0;i--){
            if(pastRound[i]==-autoMoveTurn){
                recordPointer=i;
                break;
            }
        }
    }

    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            board[i][j]=record[recordPointer][i][j];
        }
    }
    candidate=candidateRecord[recordPointer];
    enable.clear();
    do{
        turnFlag = pastRound[recordPointer];
        for(auto i:candidate){
            for(auto j:allDirect){
                findEnable(j,i.first,i.second);
            }
        }
        for(auto i:enable){
            board[i.first][i.second]=2;
        }
        endFlag++;
        if(endFlag==3){
            break;
        }
    }while(enable.size()==0);

    updateBoard();
    calculatePieces();

    judgeIsEnableUndoOrNextStep();

    cycle(0);
}

void ChessActivity::nextStep(){
    int endFlag=0;
    if(isAutoMoveActivity==0){
        recordPointer++;
    }else{
        for(int i = recordPointer+1;i < record.size();i++){
            if(pastRound[i]==-autoMoveTurn){
                recordPointer=i;
                break;
            }
        }
    }
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            board[i][j]=record[recordPointer][i][j];
        }
    }

    if(!(recordPointer>=candidateRecord.size())){
        candidate=candidateRecord[recordPointer];
    }

    enable.clear();
    do{
        turnFlag = pastRound[recordPointer];
        for(auto i:candidate){
            for(auto j:allDirect){
                findEnable(j,i.first,i.second);
            }
        }
        for(auto i:enable){
            board[i.first][i.second]=2;
        }
        endFlag++;
        if(endFlag==3){
            break;
        }
    }while(enable.size()==0);

    updateBoard();
    calculatePieces();

    judgeIsEnableUndoOrNextStep();

    cycle(0);
}

void ChessActivity::judgeIsEnableUndoOrNextStep(){
    if(recordPointer> (0 + isAutoMoveActivity + autoMoveTurn)){
        setUndoEnable(true);
    }
    else{
        setUndoEnable(false);
    }

    if(recordPointer==record.size()-1){
        setNextStepEnable(false);
    }
    else{
        setNextStepEnable(true);
    }
}

//ending part

void ChessActivity::ending(){
    QString result;
    int winner;
    calculatePieces();
    if(blackCount>whiteCount)
        result="BLACK WIN!\n";
    else if(blackCount<whiteCount)
        result="WHITE WIN!\n";
    else
        result="DRAW!\n";
    setEndMessage(result);
    emit showEndDialog();
}

//reset

void ChessActivity::reset(){

    turnFlag=1;
    candidate.clear();
    record.clear();
    candidateRecord.clear();
    pastRound.clear();
    enable.clear();
    recordPointer=-1;
    endMessage="";
    whiteCount=0;
    blackCount=0;

    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            if((i == 3 && j == 3 )||(i == 4 && j == 4)){
                board[i][j]=-1;
            }
            else if((i == 3 && j == 4 )||(i == 4 && j == 3)){
                board[i][j]=1;
            }
            else{
                board[i][j]=0;
            }

            if(i==2&&(j>1&&j<6)){
                candidate.insert({i,j});
            }
            if(i==5&&(j>1&&j<6)){
                candidate.insert({i,j});
            }
            if(j==2&&(i>1&&i<6)){
                candidate.insert({i,j});
            }
            if(j==5&&(i>1&&i<6)){
                candidate.insert({i,j});
            }
        }
    }
    pushRecord();
    pastRound.push_back(turnFlag);
    for(auto i:candidate){
        for(auto j:allDirect){
            findEnable(j,i.first,i.second);
        }
    }
    for(auto i:enable){
        board[i.first][i.second]=2;
    }
    updateBoard();
    calculatePieces();

    emit isTimerActiveChanged();
    setTime(setDuration);

    cycle(0); //update

    if(isAutoMoveActivity==1&&autoMoveTurn==turnFlag){
        cycle(1);
    }
}

void ChessActivity::cycle(int mode){
    auto obj = qobject_cast<ChessType*>(round);
    if(mode==0){
        obj->ChangeType(turnFlag);
    }
    else{
        obj->ChangeType(-turnFlag);
    }
    emit roundChanged();
    setTime(setDuration);
    if(mode==1){
        autoMove();
    }
}

void ChessActivity::autoMove(){
    int randNum;
    srand(time(NULL));
    randNum=rand()%enable.size();
    auto it=next(enable.begin(),randNum);
    move((*it).first*8+(*it).second);
}

void ChessActivity::calculatePieces(){
    int regisW=0,regisB=0;
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            if(board[i][j]==1){
                regisB++;
            }
            if(board[i][j]==-1){
                regisW++;
            }
        }
    }
    setBlackCount(regisB);
    setWhiteCount(regisW);
}

void ChessActivity::saveFile(bool isReadonly,QString fileName){
    string copyFileName=fileName.toStdString();
    set<string> reWriter;
    ifstream tagFileReader("tagFile.txt");
    if(tagFileReader){
        string regis;
        while(getline(tagFileReader,regis)){
            reWriter.insert(regis);
        }
    }

    ofstream tagFile,dataFile;
    tagFile.open("tagFile.txt");
    if(isReadonly){
        reWriter.insert(copyFileName+".txt readonly");
    }
    else{
        reWriter.insert(copyFileName+".txt");
    }
    for(auto i:reWriter){
        tagFile<<i<<"\n";
    }
    tagFile.close();

    dataFile.open(copyFileName+".txt");
    dataFile<<isAutoMoveActivity<<" "<<autoMoveTurn<<" "<<isTimerAvailable<<" "<<setDuration<<endl;
    for(int i=0;i<record.size();i++){

        for(int j=0;j<8;j++){
            for(int h=0;h<8;h++){
                dataFile<<record[i][j][h]<<" ";
            }
        }
        dataFile<<endl;

        for(auto j:candidateRecord[i]){
            dataFile<<j.first<<" "<<j.second<<" ";
        }
        dataFile<<endl;

        dataFile<<pastRound[i]<<endl;

    }

}

void ChessActivity::loadExistFile(bool isReadonly){
    QStringList  fileName;
    string reader;
    ifstream ifs("tagFile.txt");
    if(ifs){
        while(getline(ifs,reader)){

            if(isReadonly){
                if(reader.find("readonly")!=string::npos){
                    reader=reader.substr(0,reader.find("."));
                    fileName.append(QString::fromStdString(reader));
                }
            }
            else{
                if(reader.find("readonly")==string::npos){
                    reader=reader.substr(0,reader.find("."));
                    fileName.append(QString::fromStdString(reader));
                }
            }

        }
    }
    setFiles(fileName);
}

void ChessActivity::loadNormalFile(QString fileName){
    int endFlag=0;
    candidate.clear();
    record.clear();
    candidateRecord.clear();
    pastRound.clear();
    enable.clear();
    recordPointer=-1;

    string lineReader;
    ifstream ifs(fileName.toStdString()+".txt");
    ifs>>isAutoMoveActivity>>autoMoveTurn>>isTimerAvailable>>setDuration;
    ifs.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    settingReading(isAutoMoveActivity,autoMoveTurn,isTimerAvailable,setDuration);

    int readCounter=0;
    while(getline(ifs,lineReader)){

        istringstream ss(lineReader);
        int readerA,readerB;

        if(readCounter%3==0){

            vector<vector<int>> regisBoard;
            for(int i=0;i<8;i++){
                vector<int> rowRegis;
                for(int j=0;j<8;j++){
                    ss>>readerA;
                    rowRegis.push_back(readerA);
                }
                regisBoard.push_back(rowRegis);
            }
            record.push_back(regisBoard);
        }

        if(readCounter%3==1){
            set<pair<int,int>> regisCandidateRecord;
            while(ss>>readerA>>readerB){
                regisCandidateRecord.insert({readerA,readerB});
            }
            candidateRecord.push_back(regisCandidateRecord);
        }

        if(readCounter%3==2){
            ss>>readerA;
            pastRound.push_back(readerA);
            recordPointer++;
        }

        readCounter++;
    }

    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            board[i][j]=record[recordPointer][i][j];
        }
    }
    candidate=candidateRecord[recordPointer];

    do{
        turnFlag = pastRound[recordPointer];
        for(auto i:candidate){
            for(auto j:allDirect){
                findEnable(j,i.first,i.second);
            }
        }
        for(auto i:enable){
            board[i.first][i.second]=2;
        }
        endFlag++;
        if(endFlag==3){
            break;
        }
    }while(enable.size()==0);

    updateBoard();

    calculatePieces();

    judgeIsEnableUndoOrNextStep();

    cycle(0);

    if(isAutoMoveActivity==1&&autoMoveTurn==turnFlag){
        cycle(1);
    }
}

void ChessActivity::loadReadonlyFile(QString fileName){

    record.clear();
    candidateRecord.clear();
    pastRound.clear();
    recordPointer=-1;

    string lineReader;
    ifstream ifs(fileName.toStdString()+".txt");
    ifs>>isAutoMoveActivity>>autoMoveTurn>>isTimerAvailable>>setDuration;
    ifs.ignore(std::numeric_limits<std::streamsize>::max(), '\n');

    settingReading(0,0,0,0);

    int readCounter=0;
    while(getline(ifs,lineReader)){

        istringstream ss(lineReader);
        int readerA,readerB;

        if(readCounter%3==0){

            vector<vector<int>> regisBoard;
            for(int i=0;i<8;i++){
                vector<int> rowRegis;
                for(int j=0;j<8;j++){
                    ss>>readerA;
                    rowRegis.push_back(readerA);
                }
                regisBoard.push_back(rowRegis);
            }
            record.push_back(regisBoard);
        }

        if(readCounter%3==1){
            set<pair<int,int>> regisCandidateRecord;
            while(ss>>readerA>>readerB){
                regisCandidateRecord.insert({readerA,readerB});
            }
            candidateRecord.push_back(regisCandidateRecord);
        }

        if(readCounter%3==2){
            ss>>readerA;
            pastRound.push_back(readerA);
            recordPointer++;
        }

        readCounter++;
    }
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            board[i][j]=record[0][i][j];
        }
    }
    recordPointer=0;
    turnFlag=pastRound[0];
    updateBoard();
    calculatePieces();
    cycle(0);
}

void ChessActivity::reviewNextStep(){
    if(recordPointer+1<record.size()){
        recordPointer++;
        for(int i=0;i<8;i++){
            for(int j=0;j<8;j++){
                board[i][j]=record[recordPointer][i][j];
            }
        }
    }
    updateBoard();
    calculatePieces();
    turnFlag=pastRound[recordPointer];
    cycle(0);
}
void ChessActivity::reviewLastStep(){
    if(recordPointer-1>=0){
        recordPointer--;
        for(int i=0;i<8;i++){
            for(int j=0;j<8;j++){
                board[i][j]=record[recordPointer][i][j];
            }
        }
    }
    updateBoard();
    calculatePieces();
    turnFlag=pastRound[recordPointer];
    cycle(0);
}

void ChessActivity::showConvertable(int index){
    vector<pair<int,int>> convertableIndex;
    int posY=index/8;
    int posX=index%8;
    for(auto i:allDirect){
        vector<int> list = getList(i,posY,posX);
        int endFlag=0;

        for(int j=0;j<list.size();j++){
            if(list[j]==turnFlag){
                endFlag=j;
                break;
            }
        }

        for(int j=0;j<endFlag;j++){
            convertableIndex.push_back({i.first*(j+1)+posY,i.second*(j+1)+posX});
        }
    }

    for(auto i:convertableIndex){
        auto obj=qobject_cast<ChessType*>(pieces.at(i.first*8+i.second));
        if(obj){
            obj->setChangeable(true);
        }
    }
}

void ChessActivity::hideConvertable(){
    for(int i=0;i<8;i++){
        for(int j=0;j<8;j++){
            auto obj = qobject_cast<ChessType*>(pieces.at(i*8+j));
            if(obj){
                obj->setChangeable(false);
            }
        }
    }
}


