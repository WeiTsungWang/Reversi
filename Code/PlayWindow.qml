import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs
import QtCharts

Item {
    property StackView stackViewRef

    Rectangle {
        width: 960
        height: 720
        color: "#1a1a1a"

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Rectangle {
                Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                Layout.preferredWidth: parent.width * 0.7
                Layout.fillHeight: true
                color: "#1a1a1a"

                GridLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    columns: 8

                    Repeater {
                        id:board
                        model: ChessActivity.pieces
                        Rectangle {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            color: "#3a773a"
                            radius: 6
                            border.color: "#2e5e2e"

                            Rectangle {
                                id:piece
                                property int row: Math.floor(index / 8)
                                property int col: index % 8
                                property int borderWidth: model.borderWidth
                                property color chessColor: model.chessColor
                                property color borderColor: model.borderColor
                                property bool isAvailable: model.isAvailable
                                property bool isVisable: model.isVisable
                                property bool isConvertable: model.changeable
                                property real currentAngle: 0

                                anchors.centerIn: parent
                                height: parent.width*0.8
                                width: parent.width*0.8

                                visible: isVisable

                                radius: width / 2
                                color: Qt.darker(chessColor, 1.1)
                                border.width: borderWidth
                                border.color: borderColor

                                states: [
                                        State {
                                            name: "hovered"
                                            PropertyChanges {
                                                target: piece
                                                scale: 1.1
                                            }
                                        },
                                        State {
                                            name: "normal"
                                            PropertyChanges {
                                                target: piece
                                                scale: 1.0
                                            }
                                        }
                                    ]

                                transitions: [
                                        Transition {
                                            from: "normal"
                                            to: "hovered"
                                            NumberAnimation { properties: "scale"; duration: 150; easing.type: Easing.OutQuad }
                                        },
                                        Transition {
                                            from: "hovered"
                                            to: "normal"
                                            NumberAnimation { properties: "scale"; duration: 150; easing.type: Easing.OutQuad }
                                        }
                                    ]

                                transform: Rotation {
                                    origin.x: 0
                                    origin.y: 0
                                    axis.x: 1
                                    axis.y: 1
                                    axis.z: 0
                                    angle: piece.currentAngle
                                }

                                PropertyAnimation {
                                    id: flipAnim
                                    target: piece
                                    property: "currentAngle"
                                    duration: 400
                                    to: (piece.currentAngle + 180) % 360
                                }

                                MouseArea{
                                    anchors.fill: parent
                                    enabled: parent.isAvailable
                                    hoverEnabled: parent.isAvailable
                                    onClicked: {
                                        ChessActivity.move(index)
                                    }
                                    onEntered: {
                                        parent.state="hovered"
                                        ChessActivity.showConvertable(index)
                                    }
                                    onExited: {
                                        parent.state="normal"
                                        ChessActivity.hideConvertable()
                                    }
                                }
                                Connections{
                                    target: ChessActivity
                                    onFlip:{
                                        if (!flipAnim.running && sentIndex==index)
                                            flipAnim.running = true
                                    }
                                }

                                Rectangle{
                                    anchors.centerIn: parent
                                    height: 10
                                    width: 10
                                    radius: height/2
                                    color: "red"
                                    visible:parent.isConvertable
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.alignment: Qt.AlignTop | Qt.AlignRight
                Layout.preferredWidth: parent.width * 0.3
                Layout.fillHeight: true
                color: "#1a1a1a"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10

                    Rectangle {
                        id:timerArea
                        Layout.preferredHeight: parent.height * 0.1
                        Layout.preferredWidth: parent.width
                        color: "#383838"
                        radius: 10


                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10

                            Rectangle {
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.3
                                color: "#383838"

                                Button {
                                    anchors.centerIn: parent
                                    height: timerArea.height-10
                                    width: timerArea.height-10

                                    property var round: ChessActivity.round
                                    property int borderWidth: round.borderWidth
                                    property color chessColor: round.chessColor
                                    property color borderColor: round.borderColor

                                    visible: true
                                    enabled: false
                                    hoverEnabled: false

                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: width / 2
                                        color: parent.chessColor
                                        border.width: parent.borderWidth
                                        border.color: parent.borderColor
                                    }
                                }
                            }

                            Rectangle {
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.5
                                color: "#383838"

                                Timer {
                                    id: gameTimer
                                    interval: 1000
                                    running: ChessActivity.isTimerActive
                                    repeat: true
                                    onTriggered: {
                                        ChessActivity.time -= 1
                                        if (ChessActivity.time <= 0) {
                                            ChessActivity.cycle(1)
                                        }
                                    }
                                }

                                Text {
                                    anchors.centerIn: parent
                                    visible: ChessActivity.isTimerActive
                                    text: ChessActivity.time + "s"
                                    font.pixelSize: 16
                                    color: "white"
                                }
                            }
                        }
                    }

                    Rectangle {
                        id:controlRow1
                        Layout.preferredHeight: parent.height * 0.05
                        Layout.preferredWidth: parent.width
                        color: "#1c1c1c"

                        RowLayout {
                            anchors.fill: parent
                            anchors.rightMargin: 5

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isEnable: ChessActivity.undoEnable
                                property bool isPress: false
                                radius: 5
                                color: isEnable ? "#5c5c5c":"#4A4A4A"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Undo"
                                    anchors.centerIn: parent
                                    color: parent.isEnable? "white" : "#616161"
                                    font.family: "Roboto"
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
                                    hoverEnabled: parent.isEnable
                                    enabled: parent.isEnable
                                    onEntered:{
                                        parent.isHovered=true
                                        parent.scale=1.05
                                    }
                                    onExited:{
                                        parent.isHovered=false
                                        parent.scale=1.0
                                    }
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.undo()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isEnable: ChessActivity.nextStepEnable
                                property bool isPress: false
                                radius: 5
                                color: isEnable ? "#5c5c5c":"#4A4A4A"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Redo"
                                    anchors.centerIn: parent
                                    color: parent.isEnable? "white" : "#616161"
                                    font.family: "Roboto"
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
                                    hoverEnabled: parent.isEnable
                                    enabled: parent.isEnable
                                    onEntered:{
                                        parent.isHovered=true
                                        parent.scale=1.05
                                    }
                                    onExited:{
                                        parent.isHovered=false
                                        parent.scale=1.0
                                    }
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.nextStep()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }


                        }
                    }

                    Rectangle {
                        id:controlRow2
                        Layout.preferredHeight: parent.height * 0.05
                        Layout.preferredWidth: parent.width
                        color: "#1c1c1c"

                        RowLayout {
                            anchors.fill: parent
                            anchors.rightMargin: 5
                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Save"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        gameTimer.stop()
                                        saveNormal.open()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Load"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.loadExistFile(0)
                                        gameTimer.stop()
                                        load.open()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id:controlRow3
                        Layout.preferredHeight: parent.height * 0.05
                        Layout.preferredWidth: parent.width
                        color: "#1c1c1c"

                        RowLayout {
                            anchors.fill: parent
                            anchors.rightMargin: 5

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Replay"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.loadExistFile(1)
                                        gameTimer.stop()
                                        loadReadonly.open()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width*0.5
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Restart"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.reset()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }
                        }
                    }
                    Rectangle{
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        color:"#1c1c1c"
                    }


                    Rectangle {
                        id:reviewControl
                        visible: false
                        Layout.preferredHeight: parent.height * 0.05
                        Layout.preferredWidth: parent.width
                        color: "#1c1c1c"

                        RowLayout {
                            anchors.fill: parent
                            anchors.rightMargin: 5


                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.33
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "< Last Step"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.reviewLastStep();
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }


                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.33
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "Next Step >"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        ChessActivity.reviewNextStep();
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }

                            Rectangle{
                                Layout.preferredHeight: parent.height
                                Layout.preferredWidth: parent.width * 0.33
                                property bool isHovered: false
                                property bool isPress: false
                                radius: 5
                                color: "#5c5c5c"


                                Rectangle{
                                    height: parent.height
                                    width: parent.isHovered ? parent.width : 0
                                    color:parent.isPress? "#768186":"#838586"
                                    radius: parent.radius
                                    z: 1

                                    Behavior on width {
                                        NumberAnimation {
                                            duration: 100
                                            easing.type: Easing.InOutQuad
                                        }
                                    }

                                    Behavior on color{
                                        ColorAnimation {
                                            duration: 150
                                        }
                                    }
                                }

                                Text {
                                    text: "End Review"
                                    anchors.centerIn: parent
                                    color: "white"
                                    font.family: "Roboto"
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
                                    onPressed:{
                                        parent.scale=1.0
                                        parent.isPress=true
                                        reviewControl.visible=false
                                        controlRow1.visible=true
                                        controlRow2.visible=true
                                        controlRow3.visible=true
                                        ChessActivity.reset()
                                        stackViewRef.pop()
                                    }
                                    onReleased:{
                                        parent.isPress=false
                                        parent.scale=1.05
                                    }
                                }
                            }
                        }
                    }

                    Rectangle {
                        id:countDisplay
                        Layout.preferredHeight: parent.height * 0.1
                        Layout.preferredWidth: parent.width
                        color: "#383838"
                        radius: 10

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: 5

                            Rectangle {
                                Layout.preferredHeight: countDisplay.height
                                Layout.preferredWidth: countDisplay.width*0.25
                                color: "transparent"
                                Button{
                                    anchors.centerIn: parent
                                    height:parent.height-10
                                    width:parent.height-10

                                    visible: true
                                    enabled: false
                                    hoverEnabled: false

                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: width / 2
                                        color: "black"
                                        border.width: 0
                                        border.color: "black"
                                    }
                                }
                            }

                            Text {
                                Layout.preferredWidth: countDisplay.width*0.25
                                text: ChessActivity.blackCount
                                font.pixelSize: 16
                                color: "white"
                            }

                            Rectangle {
                                Layout.preferredHeight: countDisplay.height
                                Layout.preferredWidth: countDisplay.width*0.25
                                color: "transparent"
                                Button{
                                    anchors.centerIn: parent
                                    height:parent.height-10
                                    width:parent.height-10

                                    visible: true
                                    enabled: false
                                    hoverEnabled: false

                                    background: Rectangle {
                                        anchors.fill: parent
                                        radius: width / 2
                                        color: "white"
                                        border.width: 0
                                        border.color: "white"
                                    }
                                }
                            }

                            Text {
                                Layout.preferredWidth: countDisplay.width*0.25
                                text: ChessActivity.whiteCount
                                font.pixelSize: 16
                                color: "white"
                            }
                        }
                    }
                    Rectangle{
                        Layout.preferredHeight: parent.height * 0.1
                        Layout.preferredWidth: parent.width
                        property bool isHovered: false
                        property bool isPress: false
                        radius: 5
                        color: "#5c5c5c"


                        Rectangle{
                            height: parent.height
                            width: parent.isHovered ? parent.width : 0
                            color:parent.isPress? "#768186":"#838586"
                            radius: parent.radius
                            z: 1

                            Behavior on width {
                                NumberAnimation {
                                    duration: 100
                                    easing.type: Easing.InOutQuad
                                }
                            }

                            Behavior on color{
                                ColorAnimation {
                                    duration: 150
                                }
                            }
                        }

                        Text {
                            text: "Back to Menu"
                            anchors.centerIn: parent
                            color: "white"
                            font.family: "Roboto"
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
                            onPressed:{
                                parent.scale=1.0
                                parent.isPress=true
                                gameTimer.stop()
                                reviewControl.visible=false
                                controlRow1.visible=true
                                controlRow2.visible=true
                                controlRow3.visible=true
                                ChessActivity.reset()
                                stackViewRef.pop()
                            }
                            onReleased:{
                                parent.isPress=false
                                parent.scale=1.05
                            }
                        }
                    }
                }
            }
        }
    }

    Popup{
        id:confirmDialog
        height: 350
        width: 300
        anchors.centerIn: parent
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        background: Rectangle{
            color: "#4f4f4f"
            border.color: "#5d7586"
            border.width: 1
            radius: 10
        }

        ColumnLayout{
            id:endCol
            anchors.fill: parent
            anchors.leftMargin: 10
            anchors.rightMargin: 10
            anchors.topMargin: 10
            anchors.bottomMargin: 5
            Text {
                Layout.alignment: Qt.AlignCenter
                text: ChessActivity.endMessage
                font.family: "Roboto"
                font.bold: true
                font.pixelSize: 30
                color:"white"
            }

            RowLayout{
                Layout.preferredWidth: endCol.width
                Layout.preferredHeight: endCol.height/4
                spacing: 10
                Rectangle{
                    Layout.preferredWidth: endCol.width/6
                }
                Rectangle{
                    height: 60
                    width: 60
                    color: "black"
                    radius: height/2
                }
                Text {
                    text: ChessActivity.blackCount
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 20
                    color:"white"
                }
                Rectangle{
                    Layout.fillWidth: true
                }
            }

            RowLayout{
                Layout.preferredWidth: endCol.width
                Layout.preferredHeight: endCol.height/4
                spacing: 10
                Rectangle{
                    Layout.preferredWidth: endCol.width/6
                }
                Rectangle{
                    height: 60
                    width: 60
                    color: "white"
                    radius: height/2
                }
                Text {
                    text: ChessActivity.whiteCount
                    font.family: "Roboto"
                    font.bold: true
                    font.pixelSize: 20
                    color:"white"
                }
                Rectangle{
                    Layout.fillWidth: true
                }
            }

            Rectangle{
                Layout.fillHeight: true
            }

            RowLayout{
                Layout.preferredWidth: endCol.width
                Rectangle{
                    Layout.fillWidth: true
                }

                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 100
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#838586"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Start a new gmae"
                        anchors.centerIn: parent
                        color: "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            ChessActivity.reset();
                            confirmDialog.close()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 80
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#838586"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Back to menu"
                        anchors.centerIn: parent
                        color: "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            confirmDialog.close()
                            ChessActivity.reset()
                            stackViewRef.pop()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }

                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 40
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#21ff00"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Save"
                        anchors.centerIn: parent
                        color: parent.isHovered? "black" : "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            confirmDialog.close()
                            saveReadonly.open()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }
            }
        }
    }

    Popup{
        id: saveNormal
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        height: 100
        width: 200
        anchors.centerIn: parent
        background: Rectangle{
            color: "#4f4f4f"
            border.color: "#5d7586"
            border.width: 1
            radius: 10
        }
        ColumnLayout{
            anchors.fill:parent
            Text {
                Layout.alignment: Qt.AlignLeft
                text: "Enter file name"
                color: "white"
                font.family: "Roboto"
            }
            TextField {
                id: fileNameField
                placeholderText: "Enter file name"
                Layout.fillWidth: true
            }
            RowLayout{
                Rectangle{
                    Layout.fillWidth: true
                }
                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 40
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#21ff00"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Save"
                        anchors.centerIn: parent
                        color: parent.isHovered? "black" : "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            ChessActivity.saveFile(0,fileNameField.text)
                            if(ChessActivity.isTimerActive === true)
                                gameTimer.start()
                            fileNameField.text=""
                            saveNormal.close()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }


                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 40
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#ff0000"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Close"
                        anchors.centerIn: parent
                        color: parent.isHovered? "black" : "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            if(ChessActivity.isTimerActive === true)
                                gameTimer.start()
                            saveNormal.close()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }
            }
        }
    }

    Popup{
        id: saveReadonly
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
        height: 100
        width: 200
        anchors.centerIn: parent
        background: Rectangle{
            color: "#4f4f4f"
            border.color: "#5d7586"
            border.width: 1
            radius: 10
        }
        ColumnLayout{
            anchors.fill:parent
            Text {
                Layout.alignment: Qt.AlignLeft
                text: "Enter file name"
                color: "white"
                font.family: "Roboto"
            }
            TextField {
                id: fileNameFieldReadonly
                placeholderText: "Enter file name"
                Layout.fillWidth: true
            }
            RowLayout{
                Rectangle{
                    Layout.fillWidth: true
                }

                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 40
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#21ff00"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Save"
                        anchors.centerIn: parent
                        color: parent.isHovered? "black" : "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            ChessActivity.saveFile(1,fileNameFieldReadonly.text)
                            fileNameFieldReadonly.text=""
                            saveReadonly.close()
                            ChessActivity.reset()
                            stackViewRef.pop()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }


                Rectangle{
                    Layout.preferredHeight: 25
                    Layout.preferredWidth: 40
                    property bool isPress: false
                    property bool isHovered: false
                    radius: 5
                    color: "#7a7a7a"


                    Rectangle{
                        height: parent.height
                        width: parent.isHovered ? parent.width : 0
                        color: "#ff0000"
                        radius: parent.radius
                        z: 1

                        Behavior on width {
                            NumberAnimation {
                                duration: 100
                                easing.type: Easing.InOutQuad
                            }
                        }

                        Behavior on color{
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Text {
                        text: "Close"
                        anchors.centerIn: parent
                        color: parent.isHovered? "black" : "white"
                        font.family: "Roboto"
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
                        onPressed:{
                            parent.scale=1.0
                            parent.isPress=true
                            fileNameFieldReadonly.text=""
                            saveReadonly.close()
                            ChessActivity.reset()
                            stackViewRef.pop()
                        }
                        onReleased:{
                            parent.isPress=false
                            parent.scale=1.05
                        }
                    }
                }
            }
        }
    }

    Popup {
        id: load
        anchors.centerIn: parent
        height: 300
        width: 200
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            color: "#4f4f4f"
            border.color: "#5d7586"
            border.width: 1
            radius: 10
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 5
            anchors.margins:5
            Text {
                Layout.alignment: Qt.AlignLeft
                text: "Choose a file"
                color:"white"
                font.family: "Roboto"
            }
            ScrollView {
                id: fileScrollView
                Layout.fillHeight: true
                Layout.fillWidth: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: fileScrollView.availableWidth
                    spacing: 5
                    Repeater {
                        model: ChessActivity.files
                        // Button {
                        //     Layout.preferredHeight: 40
                        //     Layout.fillWidth: true
                        //     text: modelData

                        //     onClicked: {
                        //         ChessActivity.loadNormalFile(text)
                        //         load.close()
                        //     }
                        // }
                        Rectangle{
                            Layout.preferredHeight: 40
                            Layout.fillWidth: true
                            property bool isPress: false
                            property bool isHovered: false
                            property var fileText: modelData
                            radius: 5
                            color: "#7a7a7a"


                            Rectangle{
                                height: parent.height
                                width: parent.isHovered ? parent.width : 0
                                color: "#21ff00"
                                z: 1

                                Behavior on width {
                                    NumberAnimation {
                                        duration: 100
                                        easing.type: Easing.InOutQuad
                                    }
                                }
                            }

                            Text {
                                text: parent.fileText
                                anchors.centerIn: parent
                                color: parent.isHovered? "black" : "white"
                                font.family: "Roboto"
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
                                onPressed:{
                                    parent.scale=1.0
                                    parent.isPress=true
                                    ChessActivity.loadNormalFile(parent.fileText)
                                    load.close()
                                }
                                onReleased:{
                                    parent.isPress=false
                                    parent.scale=1.05
                                }
                            }
                        }
                    }
                }
            }

            Rectangle{
                Layout.preferredHeight: 25
                Layout.preferredWidth: 40
                Layout.alignment: Qt.AlignRight
                property bool isPress: false
                property bool isHovered: false
                radius: 5
                color: "#7a7a7a"


                Rectangle{
                    height: parent.height
                    width: parent.isHovered ? parent.width : 0
                    color: "#ff0000"
                    radius: parent.radius
                    z: 1

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on color{
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                Text {
                    text: "Close"
                    anchors.centerIn: parent
                    color: parent.isHovered? "black" : "white"
                    font.family: "Roboto"
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
                    onPressed:{
                        parent.scale=1.0
                        parent.isPress=true
                        if(ChessActivity.isTimerActive === true)
                            gameTimer.start()
                        load.close()
                    }
                    onReleased:{
                        parent.isPress=false
                        parent.scale=1.05
                    }
                }
            }
        }
    }

    Popup {
        id: loadReadonly
        anchors.centerIn: parent
        height: 300
        width: 200
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose

        background: Rectangle {
            color: "#4f4f4f"
            border.color: "#5d7586"
            border.width: 1
            radius: 10
        }

        ColumnLayout {
            anchors.fill: parent
            spacing: 5
            anchors.margins:5
            Text {
                Layout.alignment: Qt.AlignLeft
                text: "Choose a file"
                color:"white"
                font.family: "Roboto"
            }
            ScrollView {
                id: fileScrollViewReadonly
                Layout.fillHeight: true
                Layout.fillWidth: true
                ScrollBar.vertical.policy: ScrollBar.AlwaysOff
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ColumnLayout {
                    width: fileScrollViewReadonly.availableWidth
                    spacing: 5
                    Repeater {
                        model: ChessActivity.files
                        Rectangle{
                            Layout.preferredHeight: 40
                            Layout.fillWidth: true
                            property bool isPress: false
                            property bool isHovered: false
                            property var fileText: modelData
                            radius: 5
                            color: "#7a7a7a"


                            Rectangle{
                                height: parent.height
                                width: parent.isHovered ? parent.width : 0
                                color: "#21ff00"
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
                                text: parent.fileText
                                anchors.centerIn: parent
                                color: parent.isHovered? "black" : "white"
                                font.family: "Roboto"
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
                                onPressed:{
                                    parent.scale=1.0
                                    parent.isPress=true
                                    ChessActivity.loadReadonlyFile(parent.fileText)
                                    reviewControl.visible=true
                                    controlRow1.visible=false
                                    controlRow2.visible=false
                                    controlRow3.visible=false
                                    loadReadonly.close()
                                }
                                onReleased:{
                                    parent.isPress=false
                                    parent.scale=1.05
                                }
                            }
                        }
                    }
                }
            }


            Rectangle{
                Layout.preferredHeight: 25
                Layout.preferredWidth: 40
                Layout.alignment: Qt.AlignRight
                property bool isPress: false
                property bool isHovered: false
                radius: 5
                color: "#7a7a7a"


                Rectangle{
                    height: parent.height
                    width: parent.isHovered ? parent.width : 0
                    color: "#ff0000"
                    radius: parent.radius
                    z: 1

                    Behavior on width {
                        NumberAnimation {
                            duration: 100
                            easing.type: Easing.InOutQuad
                        }
                    }

                    Behavior on color{
                        ColorAnimation {
                            duration: 150
                        }
                    }
                }

                Text {
                    text: "Close"
                    anchors.centerIn: parent
                    color: parent.isHovered? "black" : "white"
                    font.family: "Roboto"
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
                    onPressed:{
                        parent.scale=1.0
                        parent.isPress=true
                        if(ChessActivity.isTimerActive === true)
                            gameTimer.start()
                        loadReadonly.close()
                    }
                    onReleased:{
                        parent.isPress=false
                        parent.scale=1.05
                    }
                }
            }
        }
    }


    Connections {
        target: ChessActivity
        onShowEndDialog: {
            confirmDialog.open()
            gameTimer.stop()
        }
    }
}
