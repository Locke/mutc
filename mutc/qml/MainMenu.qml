import Qt 4.7

Rectangle {
    id: main_menu
    opacity: 0

    width: 320
    height: 240

    color: style.backgroundColor
    state: "hidden"

    Style { id: style }

    signal addAccount
    signal addPanel
    signal needArgs(string uuid, string panel_type, string ask_text)
    signal optionsButtonClicked

    property alias accountModel: account_menu_view.model
    property alias panelModel: panel_view.model

    property alias for_account: panel_view.for_account
    property alias panel_type: panel_view.panel_type
    property alias need_args: panel_view.need_args

    Behavior on opacity {
        NumberAnimation { duration: 250 }
    }

    TitleBar {
        id: title
        text: "Main menu"
        color: border.color
    }
    Button {
        id: add_account_button
        button_text: "Add account"
        height: 22
        width: parent.width
        border {
            width: title.border.width
            color: title.border.color
        }
        anchors {
            top: title.bottom
            left: parent.left
            right: parent.right
            topMargin: 5
        }
        onButtonClicked: {
            //new_account_dialog.state = 'open';
            addAccount()
            main_menu.state = 'hidden';
        }
    }

    Item {
        id: view_container
        anchors {
            top: add_account_button.bottom
            bottom: options_button.top
            left: parent.left
            right: parent.right
            topMargin: 5
        }
        ListView {
            id: account_menu_view

            anchors { fill: parent }

            delegate: Button {
                button_text: "Create panel for `" + screen_name + "` >"
                height: 22
                width: 320
                border {
                    width: title.border.width
                    color: title.border.color
                }
                onButtonClicked: {
                    panel_view.for_account = account_obj
                    main_menu.state = "panel_menu"
                }
            }
        }

        ListView {
            id: panel_view
            model: panel_model

            property variant for_account
            property string panel_type
            property string need_args

            anchors { fill: parent }

            //height: main_menu.height / 2

            delegate: Button {
                button_text: type
                height: 22
                width: 320

                border {
                    width: title.border.width
                    color: title.border.color
                }

                onButtonClicked: {
                    main_menu.state = "hidden";
                    panel_view.panel_type = type;
                    panel_view.need_args = ask_text;
                    if (!args)
                        addPanel();
                    else
                        needArgs(panel_view.for_account, type, ask_text);
                }
            }
        }
    }

    Button {
        id: options_button
        button_text: "Options"
        height: 22
        width: parent.width
        border {
            width: title.border.width
            color: title.border.color
        }
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 5
        }
        onButtonClicked: {
            main_menu.state = "hidden"
            main_menu.optionsButtonClicked()
        }
    }

    anchors {
        bottom: toolbar_row.top
        right: parent.right
    }

    states: [
        State {
            name: "main_menu"
            PropertyChanges {
                target: account_menu_view
                opacity: 1
                visible: true
            }
            PropertyChanges {
                target: panel_view
                opacity: 0
                visible: false
            }
            PropertyChanges {
                target: main_menu
                opacity: 1
            }
        },
        State {
            name: "panel_menu"
            PropertyChanges {
                target: account_menu_view
                visible: false
                opacity: 0
            }
            PropertyChanges {
                target: panel_view
                visible: true
                opacity: 1
            }
            PropertyChanges {
                target: main_menu
                opacity: 1
            }
        },
        State {
            name: "hidden"
            PropertyChanges {
                target: main_menu
                opacity: 0
            }
            PropertyChanges {
                target: account_menu_view
                visible: account_menu_view.opacity
            }
            PropertyChanges {
                target: panel_view
                visible: panel_view.opacity
            }

        }

    ]

    transitions: [
        Transition {
            NumberAnimation { property: "opacity"; duration: 250 }
        }
    ]
}
