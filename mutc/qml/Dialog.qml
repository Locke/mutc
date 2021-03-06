import Qt 4.7

Rectangle {
    width: 320
    height: 90

    signal dialogAccepted

    property bool accepted: false
    property string value: ""

    id: dialog

    color: style.dialogBackground

    property alias text: prompt_text.text
    property alias title: title_text.text

    border {
        width: 1
        color: style.borderColor
    }

    Style { id: style }

    Toolbar {
        id: title_bar
        color: style.dialogBackground
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 1
        }
        height:22

        Text {
            id: title_text
            color: "white"
            text: "Title text"
            anchors {
                centerIn: parent
            }
        }
    }

    Text {
        id: prompt_text
        text: "Prompt text"
        color: "white"
        anchors {
            left: parent.left
            right: parent.right
            top: title_bar.bottom
            margins: 5
        }
        height: 22
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        id: ok_button
        button_text: "ok"
        anchors {
            bottom: parent.bottom
            right: parent.right
            topMargin: 10
            rightMargin: 5
            bottomMargin: 5
        }
        width: parent.width / 3
        height: 22

        onButtonClicked: {
            accept()
        }
    }
    Button {
        button_text: "cancel"
        anchors {
            bottom: parent.bottom
            right: ok_button.left
            topMargin: 10
            rightMargin: 5
            bottomMargin: 5
        }
        width: parent.width / 3
        height: 22

        onButtonClicked: {
            dialog.state = "hidden"
        }
    }

    states: [
        State {
            name: "hidden"
            PropertyChanges {
                target: dialog
                opacity: 0
            }
        },
        State {
            name: "visible"
            PropertyChanges {
                target: dialog
                opacity: 1
            }
        }
    ]

    function accept() {
        accepted = true
        state = "hidden"
        dialogAccepted()
    }

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }
}
