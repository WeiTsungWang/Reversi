pragma Singleton
import QtQuick 6.8

QtObject {
    property int playerCount: 1
    property string firstMove: "player"
    property bool countdownOn: false
    property int countdownSeconds: 30
}
