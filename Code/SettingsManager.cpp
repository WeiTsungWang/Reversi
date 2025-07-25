// SettingsManager.cpp
#include "SettingsManager.h"

SettingsManager::SettingsManager(QObject *parent) : QObject(parent) {}

int SettingsManager::playerCount() const { return m_playerCount; }
int SettingsManager::firstMove() const { return m_firstMove; }
bool SettingsManager::countdown() const { return m_countdown; }
int SettingsManager::countdownSec() const { return m_countdownSec; }

void SettingsManager::setPlayerCount(int value) {
    if (m_playerCount != value) {
        m_playerCount = value;
        emit playerCountChanged();
    }
}

void SettingsManager::setFirstMove(const int &value) {
    if (m_firstMove != value) {
        m_firstMove = value;
        emit firstMoveChanged();
    }
}

void SettingsManager::setCountdown(bool value) {
    if (m_countdown != value) {
        m_countdown = value;
        emit countdownChanged();
    }
}

void SettingsManager::setCountdownSec(int value) {
    if (m_countdownSec != value) {
        m_countdownSec = value;
        emit countdownSecChanged();
    }
}
