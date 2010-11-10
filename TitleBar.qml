import Qt 4.7

Toolbar {
    id: title_bar

    property alias text: title.text

    anchors {
        top: parent.top
        left: parent.left
        right: parent.right
        topMargin: 1
    }
    height:22

    Text {
        id: title
        text: ""
        color: "white"
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }
    }
}
