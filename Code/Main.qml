import QtQuick 6.8
import QtQuick.Controls 6.8
import QtQuick.Layouts 6.8

Window {
    visible: true
    width: 960
    height: 720
    title: "MainScreen"
    color: "#3c3c3c"

    StackView {
        id: stackView
        anchors.fill: parent
        pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 0
                }
            }

        pushExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 0
            }
        }

        popEnter: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 0
                to: 1
                duration: 0
            }
        }

        popExit: Transition {
            PropertyAnimation {
                property: "opacity"
                from: 1
                to: 0
                duration: 0
            }
        }

        initialItem: mainPage
    }

    Popup {
        id: rulePopup
        width: 400
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        anchors.centerIn: parent

        background:  Rectangle{
            anchors.fill: parent
            color: "#3c3c3c"
            border.color: "#5d7586"
            border.width: 2
            radius: 5
        }

        Rectangle {
            anchors.fill:parent
            color: "transparent"
            anchors.margins: 10
            ColumnLayout {
                spacing: 20
                width: parent.width
                height: parent.height

                Text {
                    id: ruleText
                    text: rulePopup.theRule[rulePopup.index]
                    font.pixelSize: 20
                    font.family: "Roboto"
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    wrapMode: Text.Wrap
                }

                RowLayout{
                    Layout.preferredWidth: parent.width
                    Rectangle{
                        Layout.preferredWidth: parent.width * 0.3
                        Layout.preferredHeight: 30
                        property bool isHovered: false
                        property bool isPress: false
                        radius: 5
                        color:rulePopup.index > 0 ? "#5d7586" : "#aab3b9"


                        Rectangle{
                            height: parent.height
                            width: parent.isHovered ? parent.width : 0
                            color: parent.isPress ? "#6d6f71" : "#838586"
                            radius: parent.radius
                            z: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }


                        }

                        Text {
                            text: "< Previous"
                            anchors.centerIn: parent
                            color: rulePopup.index > 0 ? "white" :"#616161"
                            z: 2
                        }

                        Behavior on scale{
                            NumberAnimation {
                                property: "scale"
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.Linear
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: rulePopup.index > 0
                            enabled: rulePopup.index > 0
                            onEntered:{
                                parent.isHovered=true
                                parent.scale=1.05
                            }
                            onExited:{
                                parent.isHovered=false
                                parent.scale=1.0
                            }
                            onPressed: {
                                parent.isPress = true
                                parent.scale = 1.0
                                rulePopup.index -= 1
                                ruleText.text = rulePopup.theRule[rulePopup.index]
                            }
                            onReleased: {
                                parent.isPress = false
                                parent.scale = 1.05
                            }
                        }
                    }
                    Rectangle{
                        Layout.preferredWidth: parent.width * 0.3
                        Layout.preferredHeight: 30
                        property bool isHovered: false
                        property bool isPress: false
                        radius: 5
                        color:rulePopup.index < rulePopup.theRule.length - 1 ? "#5d7586" : "#aab3b9"


                        Rectangle{
                            height: parent.height
                            width: parent.isHovered ? parent.width : 0
                            color: parent.isPress ? "#6d6f71" : "#838586"
                            radius: parent.radius
                            z: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }


                        }

                        Text {
                            text: "Next >"
                            anchors.centerIn: parent
                            color: rulePopup.index < rulePopup.theRule.length - 1 ? "white" :"#616161"
                            z: 2
                        }

                        Behavior on scale{
                            NumberAnimation {
                                property: "scale"
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 200
                                easing.type: Easing.Linear
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: rulePopup.index < rulePopup.theRule.length - 1
                            enabled: rulePopup.index < rulePopup.theRule.length - 1
                            onEntered:{
                                parent.isHovered=true
                                parent.scale=1.05
                            }
                            onExited:{
                                parent.isHovered=false
                                parent.scale=1.0
                            }
                            onPressed: {
                                parent.isPress = true
                                parent.scale = 1.0
                                rulePopup.index += 1
                                ruleText.text = rulePopup.theRule[rulePopup.index]
                            }
                            onReleased: {
                                parent.isPress = false
                                parent.scale = 1.05
                            }
                        }
                    }

                    Rectangle{
                        Layout.preferredWidth: parent.width * 0.3
                        Layout.preferredHeight: 30
                        property bool isHovered: false
                        property bool isPress: false
                        radius: 5
                        color: "#5d7586"

                        Rectangle{
                            height: parent.height
                            width: parent.isHovered ? parent.width : 0
                            color: "#6d6f71"
                            radius: parent.radius
                            z: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        Text {
                            text: "Close"
                            anchors.centerIn: parent
                            color: "white"
                            z: 2
                        }

                        Behavior on scale{
                            NumberAnimation {
                                property: "scale"
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: true
                            onEntered:{
                                parent.isHovered=true
                                parent.scale=1.05
                            }
                            onExited:{
                                parent.isHovered=false
                                parent.scale=1.0
                            }
                            onPressed: {
                                parent.isPress = true
                                parent.scale = 1.0
                                rulePopup.close()
                            }
                            onReleased: {
                                parent.isPress = false
                                parent.scale = 1.05
                            }
                        }
                    }
                }
            }
        }

        property int index: 0
        property var theRule: [
            "1. Two players compete, using 64 identical game pieces ('disks') that are light on one side and dark on the other.",
            "2. Each player chooses one color to use throughout the game.",
            "3. Players take turns placing one disk on an empty square, with their assigned color facing up.",
            "4. After a play is made, any disks of the opponent's color that lie in a straight line bounded by the one just played and another one in the current player's color are turned over.",
            "5. When all playable empty squares are filled, the player with more disks showing in their own color wins the game."
        ]
    }
    Popup {
        id: contactPopup
        width: 400
        height: 300
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        anchors.centerIn: parent

        background: Rectangle{
            anchors.fill: parent
            color: "#3c3c3c"
            border.color: "#5d7586"
            border.width: 2
            radius: 5
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            anchors.margins: 10

            ColumnLayout {
                spacing: 20
                width: parent.width
                height: parent.height

                Text {
                    id: contactText
                    text: "B11315038 Chih-Hua Zhang (Julius)\nE-mail: B11315038@mail.ntust.edu.tw\n\nB11315046 Yu-Ming Xu (Min)\nE-mail: B11315046@mail.ntust.edu.tw\n\nB11330046 Wei-Tsung Wang (Jason)\nE-mail: B11330046@mail.ntust.edu.tw"
                    font.pixelSize: 20
                    font.family: "Roboto"
                    color: "#ffffff"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.fillWidth: true
                    wrapMode: Text.Wrap
                }

                Rectangle{
                    Layout.fillWidth: true
                    Layout.preferredHeight: 30
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Close"
                        anchors.centerIn: parent
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            contactPopup.close()
                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }
            }
        }

        property int index: 0
        property var theRule: [
            "1. Two players compete, using 64 identical game pieces ('disks') that are light on one side and dark on the other.",
            "2. Each player chooses one color to use throughout the game.",
            "3. Players take turns placing one disk on an empty square, with their assigned color facing up.",
            "4. After a play is made, any disks of the opponent's color that lie in a straight line bounded by the one just played and another one in the current player's color are turned over.",
            "5. When all playable empty squares are filled, the player with more disks showing in their own color wins the game."
        ]
    }
    Popup {
        id: settingPopup
        objectName: "settingPopup"
        width: 400
        height: 400
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape
        anchors.centerIn: parent

        background: Rectangle{
            anchors.fill: parent
            color: "#3c3c3c"
            border.color: "#5d7586"
            border.width: 2
            radius: 5
        }

        Rectangle {
            anchors.fill: parent
            color: "transparent"

            Item {
                anchors.fill: parent
                anchors.margins: 20

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 10

                    // 玩家人數
                    GroupBox {
                        title: "Number of Player"
                        font.family: "Roboto"
                        Layout.fillWidth: true
                        RowLayout {
                            spacing: 10
                            RadioButton {
                                id: onePlayer
                                objectName: "onePlayer"
                                checked: settingsManager.playerCount === 0
                                onCheckedChanged: if (checked) settingsManager.playerCount = 1
                                contentItem: Text {
                                    text: "     One Player"
                                    font.family: "Roboto"
                                    color: onePlayer.enabled ? "#FFFFFF" : "#000000"
                                }
                            }
                            RadioButton {
                                id: twoPlayers
                                objectName: "twoPlayers"
                                text: "Two Players"
                                contentItem: Text {
                                    text: "     Two Players"
                                    font.family: "Roboto"
                                    color: twoPlayers.enabled ? "#FFFFFF" : "#000000"
                                }
                                checked: settingsManager.playerCount === 1
                                onCheckedChanged: if (checked) settingsManager.playerCount = 0
                            }
                        }
                    }

                    // 下棋順序
                    GroupBox {
                        title: "Turn Order"
                        font.family: "Roboto"
                        enabled: onePlayer.checked
                        Layout.fillWidth: true
                        RowLayout {
                            spacing: 10
                            RadioButton {
                                id: playerFirst
                                objectName: "playerFirst"
                                contentItem: Text {
                                    text: "     Player First"
                                    font.family: "Roboto"
                                    color: playerFirst.enabled ? "#FFFFFF" : "#616161"
                                }
                                checked: settingsManager.firstMove === -1
                                onCheckedChanged: if (checked) settingsManager.firstMove = -1
                            }
                            RadioButton {
                                id: computerFirst
                                objectName: "computerFirst"
                                text: "Computer First"
                                contentItem: Text {
                                    text: "     Computer First"
                                    font:computerFirst.font
                                    color: computerFirst.enabled ? "#FFFFFF" : "#616161"
                                }
                                checked: settingsManager.firstMove === 1
                                onCheckedChanged: if (checked) settingsManager.firstMove = 1
                            }
                        }
                    }

                    // 倒數計時
                    CheckBox {
                        id: countdownEnabled
                        objectName: "countdownEnabled"
                        text: "Enable Countdown"
                        contentItem: Text {
                            text: "     Enable Countdown"
                            font.family: "Roboto"
                            color: countdownEnabled.enabled ? "#FFFFFF" : "#000000"
                        }
                        checked: settingsManager.countdown
                        onCheckedChanged: settingsManager.countdown = checked
                    }

                    RowLayout {
                        spacing: 10
                        Label {
                            text: "Countdown Seconds: "
                            font.family: "Roboto"
                            color: "#FFFFFF"
                        }
                        SpinBox {
                            id: countdownSeconds
                            objectName: "countdownSeconds"
                            from: 10
                            to: 60
                            editable: true
                            value: settingPopup.countdownSec
                            onValueChanged: settingsManager.countdownSec = value
                            enabled: countdownEnabled.checked
                        }
                    }

                    Rectangle{
                        Layout.fillWidth: true
                        Layout.preferredHeight: 30
                        property bool isHovered: false
                        property bool isPress: false
                        radius: 5
                        color: "#5d7586"

                        Rectangle{
                            height: parent.height
                            width: parent.isHovered ? parent.width : 0
                            color: "#6d6f71"
                            radius: parent.radius
                            z: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }
                        }

                        Text {
                            text: "Close"
                            anchors.centerIn: parent
                            color: "white"
                            z: 2
                        }

                        Behavior on scale{
                            NumberAnimation {
                                property: "scale"
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        MouseArea{
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: true
                            onEntered:{
                                parent.isHovered=true
                                parent.scale=1.05
                            }
                            onExited:{
                                parent.isHovered=false
                                parent.scale=1.0
                            }
                            onPressed: {
                                parent.isPress = true
                                parent.scale = 1.0
                                settingPopup.close()
                            }
                            onReleased: {
                                parent.isPress = false
                                parent.scale = 1.05
                            }
                        }
                    }
                }
            }
        }

        property int playerCount: 1
        property string firstMove: "player"
        property bool countdown: false
        property int countdownSec: 30
    }

    // 主窗口內容
    Component{
        id:mainPage
        RowLayout{
            anchors.fill: parent
            ColumnLayout {
                spacing: 15  // 增加適中的間距
                Layout.preferredHeight: parent.height
                Layout.preferredWidth: parent.width/2

                Text {
                    text: "Welcome to Reversi!"
                    font.pixelSize: 28
                    font.bold: true
                    color: "#fffeac"
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle{
                    Layout.preferredHeight: 25
                }

                Rectangle{
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Play"
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        property var playWindowInstance: null
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            if (playWindowInstance === null) {
                                var component = Qt.createComponent(Qt.resolvedUrl("PlayWindow.qml"))
                                if (component.status === Component.Ready) {
                                    playWindowInstance = component.createObject(stackView, {
                                        stackViewRef: stackView
                                    })
                                }
                            }
                            if (playWindowInstance !== null) {
                                stackView.push(playWindowInstance)
                            }
                            if (settingsManager.playerCount === 0) {
                                ChessActivity.settingReading(settingsManager.playerCount, 0, settingsManager.countdown, settingsManager.countdownSec)
                            } else {
                                ChessActivity.settingReading(settingsManager.playerCount, settingsManager.firstMove, settingsManager.countdown, settingsManager.countdownSec)
                            }
                            ChessActivity.reset()
                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Settings"
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        property var playWindowInstance: null
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            settingPopup.open()

                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Contact Us"
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        property var playWindowInstance: null
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            contactPopup.open()

                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Rules"
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        property var playWindowInstance: null
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            rulePopup.open()

                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredWidth: parent.width * 0.5
                    Layout.preferredHeight: 30
                    Layout.alignment: Qt.AlignCenter
                    property bool isHovered: false
                    property bool isPress: false
                    radius: 5
                    color: "#5d7586"

                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#6d6f71"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }
                    }

                    Text {
                        text: "Quit"
                        anchors.centerIn: parent
                        font.family: "Roboto"
                        color: "white"
                        z: 2
                    }

                    Behavior on scale{
                        NumberAnimation {
                            property: "scale"
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    MouseArea{
                        property var playWindowInstance: null
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: true
                        onEntered:{
                            parent.isHovered=true
                            parent.scale=1.05
                        }
                        onExited:{
                            parent.isHovered=false
                            parent.scale=1.0
                        }
                        onPressed: {
                            parent.isPress = true
                            parent.scale = 1.0
                            Qt.quit()

                        }
                        onReleased: {
                            parent.isPress = false
                            parent.scale = 1.05
                        }
                    }
                }
            }

            ColumnLayout{
                Layout.fillHeight: true
                Layout.fillWidth: true

                Rectangle{
                    Layout.fillHeight: true
                }

                Image {
                    source: "qrc:/image/backGround.png" //path should be change
                    Layout.alignment: Qt.AlignHCenter
                    onStatusChanged: {
                        if (status === Image.Error) {
                            console.log("圖片加載失敗，請檢查路徑");
                        }
                    }
                }
            }

        }
    }

}
