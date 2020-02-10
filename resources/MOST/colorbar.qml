import QtQuick 2.2

Rectangle {
    id: base
    width: 50
    height: 50
    color: "#3e3e3e"

    property alias barColor: bar.color
    property real fraction

    Rectangle {
        id: bar
        radius: 2
        anchors.margins: 1
        anchors.left: base.left
        anchors.right: base.right
        anchors.bottom: base.bottom
        height: fraction*(base.height-2)
    }
}
