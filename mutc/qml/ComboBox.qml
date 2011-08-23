/****************************************************************************
**
** Copyright (C) 2010 Nokia Corporation and/or its subsidiary(-ies).
** All rights reserved.
** Contact: Nokia Corporation (qt-info@nokia.com)
**
** This file is part of the FOO module of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:LGPL-ONLY$
** GNU Lesser General Public License Usage
** This file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** If you have questions regarding the use of this file, please contact
** Nokia at qt-info@nokia.com.
** $QT_END_LICENSE$
**
****************************************************************************/
import Qt 4.7

Rectangle {
    id: combobox;

    property int elementsToShow;
    property alias current: value.text;
    property alias model: combobox_elements.model;
    property alias currentIndex: combobox_elements.currentIndex;

    width: 312;
    height: 24;
    elementsToShow: 5;

    color: "#00000000"

    Style { id: style }

    function getText(){
        return "foobar";
    }

    BorderImage {
        id: background;
        source: "combobox.png";
        anchors.fill: parent;
        border.left: 5;
        border.right: 5;
    }

    Text {
        id: value;
        anchors.verticalCenter: parent.verticalCenter;
        anchors.left: background.left;
        anchors.right: marker.left;
        anchors.leftMargin: 5;
        color: style.textColor;
    }

    BorderImage {
        id: marker;
        source: "combobox-marker.png";
        border.left:5;
        border.right:5;
        anchors.verticalCenter: background.verticalCenter;
        anchors.right: background.right;
        anchors.rightMargin: 10;
    }

    MouseArea {
        id: markerArea;
        anchors.fill: background;
        onClicked: {
            combobox_list.state == "" ? combobox_list.state = "shown" : combobox_list.state = "";
            combobox_elements.currentIndex = combobox_list.lastIndex;
        }
    }

    TopLevelItem {
        id: combobox_list;
        property int lastIndex;

        opacity: 0;
        height: Math.min(background.height * combobox_elements.count,
                         background.height * combobox.elementsToShow);

        anchors.top: background.bottom;
        anchors.left: background.left;
        anchors.right: background.right;

        Component {
            id: delegate
            Item {
                id: wrapper
                width: background.width;
                height: background.height;

                Row {
                    x: 5;
                    y: 5;
                    spacing: 5;
                    Text {
                        text: content;
                        color: "white";
                    }
                    Image {
                        source: icon;
                        anchors.verticalCenter: parent.verticalCenter;
                        height: wrapper.height - 10;
                    }
                }

                function selectItem(index) {
                    combobox.current = combobox_elements.model.get(index).content;
                    combobox_list.lastIndex = index;
                    combobox_list.state = "";
                }

                MouseArea {
                    anchors.fill: parent;
                    hoverEnabled: true;

                    onEntered: {
                        combobox_elements.currentIndex = index;
                    }
                    onClicked: selectItem(index);
                }

                Keys.onPressed: {
                    if (event.key == Qt.Key_Enter || event.key == Qt.Key_Return) {
                        selectItem(index);
                    } else if (event.key == Qt.Key_Escape) {
                        combobox_list.state = "";
                    }
                }
            }
        }

        Component {
            id: highlight
            Rectangle {
                color: style.highlightColor
                border.color: style.borderColor;
            }
        }


        Rectangle {
            id: listBackground;
            border.color: style.borderColor;
            anchors.fill: parent;
            color: style.backgroundColor
        }

        ListView {
            id: combobox_elements;
            anchors.fill: parent;

            clip:true;
            focus: true;
            //overShoot: false;
            keyNavigationWraps: true;

            delegate: delegate;
            highlight: highlight;

            //locke

            model: combobox_model;
        }

        states: [
            State {
                name: "shown";
                PropertyChanges {
                    target: combobox_list;
                    opacity: 1;
                }
            }
        ]

        transitions: [
            Transition {
                from: "shown";
                to: "";
                NumberAnimation {
                    target: combobox_list;
                    properties: "opacity";
                    easing.type: "OutCubic";
                    duration: 500;
                }
            }
        ]
    }
}
