// SettingsManager.h
#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>

class SettingsManager : public QObject {
    Q_OBJECT
    Q_PROPERTY(int playerCount READ playerCount WRITE setPlayerCount NOTIFY playerCountChanged)
    Q_PROPERTY(int firstMove READ firstMove WRITE setFirstMove NOTIFY firstMoveChanged)
    Q_PROPERTY(bool countdown READ countdown WRITE setCountdown NOTIFY countdownChanged)
    Q_PROPERTY(int countdownSec READ countdownSec WRITE setCountdownSec NOTIFY countdownSecChanged)

public:
    explicit SettingsManager(QObject *parent = nullptr);

    int playerCount() const;
    int firstMove() const;
    bool countdown() const;
    int countdownSec() const;

public slots:
    void setPlayerCount(int value);
    void setFirstMove(const int &value);
    void setCountdown(bool value);
    void setCountdownSec(int value);

signals:
    void playerCountChanged();
    void firstMoveChanged();
    void countdownChanged();
    void countdownSecChanged();

private:
    int m_playerCount = 1;
    int m_firstMove = 1;
    bool m_countdown = false;
    int m_countdownSec = 30;
};

#endif // SETTINGSMANAGER_H
