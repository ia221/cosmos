import QtQuick 2.2
import QtQuick.Controls 1.2

import COSMOS 1.0

Item {
    width: 5
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter
    z:10

    Rectangle {
        id: hilightBorder
        color: "#00000000"
        anchors.fill: parent
        anchors.margins: -1
        visible: true
        border.color: "#ff0000"
        Rectangle {
            id: hilight
            color: "#8866aaff"
            anchors.fill: parent
            anchors.leftMargin: -1
            anchors.rightMargin: -1
            visible: false
        }
        Rectangle {
            id: selectedHilight
            color: "#3366ff"
            anchors.fill: parent
            anchors.leftMargin: -1
            anchors.rightMargin: -1
            visible: false
        }
    }

    Rectangle {
        id: conditionalSweep
        z: -5
        rotation: -90
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        width: parent.height-2
        height: parent.height-2
        gradient: Gradient {
            GradientStop {
                position: 0
                color: Support.alterAlpha(baseColor, 0.5);
            }

            GradientStop {
                position: 1
                color: Support.alterAlpha(baseColor, 0);
            }
        }

        visible: event && (event.flag & Event.FlagConditional)
    }

    Item {
        anchors.fill: parent
        clip: true

        Rectangle {
            id: icon
            color: {
                if (editable) return mouseOver ? Qt.lighter(baseColor, 1.5) : baseColor;
                else return Qt.tint(baseColor, "#70a0a0a0");
            }
            radius: 2
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: event!=null && (event.flag & (Event.FlagPair | Event.FlagExit)) ? (event.flag & Event.FlagExit ? parent.left : parent.right) : parent.horizontalCenter
            width: parent.width
            height: parent.height
        }
    }

    property alias iconVisible: icon.visible
    property alias hilighted: hilight.visible
    property alias selected: selectedHilight.visible
    property bool editable: true

    property Event event

    property bool mouseOver: event!=null ? Math.abs((hoverUtc-event.primaryUtc)*zoomFactor) < width/2 : false

    property color baseColor: "#0000ff"

    QtObject {
        id: local

        function orphanedUpdated(orphaned) {
            hilightBorder.border.width = orphaned;
        }

        function selectedUpdated(sel) {
            selected = sel;
        }
    }

    onEventChanged: {
        if (event==undefined) return;
        rebindX();
        baseColor = Qt.binding(function () {return event ? event.color : "blue";});
        local.orphanedUpdated(event.orphaned);
        event.orphanedChanged.connect(local.orphanedUpdated);
        local.selectedUpdated(event.selected);
        event.selectedChanged.connect(local.selectedUpdated);

    }

    Component.onDestruction: {
        if (event!=undefined) {
            event.orphanedChanged.disconnect(local.orphanedUpdated);
            event.selectedChanged.disconnect(local.selectedUpdated);
        }
    }

    MouseArea {
        id: eventArea
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton //Eventually this thing could have its own context menu
        drag.target: if (editable) parent
        cursorShape: if (editable) "SizeHorCursor"
        drag.axis: Drag.XAxis
        drag.onActiveChanged: {
            if (drag.active) hilighted = true;
            else {
                updateUtc();
                rebindX();
                hilighted = false;
            }
        }
        onClicked: {
            if (event) {
                if (mouse.button==Qt.LeftButton) event.selected = !event.selected;
                else if (mouse.button==Qt.RightButton) mnu.popup();
            }
        }

        Menu {
            id: mnu
            MenuItem {
                text: "Edit Event Properties..."
                onTriggered: openEventDialog(event)
            }
            MenuItem {
                text: "Delete"
                onTriggered: {
                    Support.changeQObjectParent(event, null);
                    var idx = eventIdx(event);
                    if (idx!=-1) CommandAssembler.commandQueue.removeAt(idx);
                }
            }
        }
    }

    function setLeftBound(bound) {
        if (bound != undefined) { //Why do I even check this?
            if (typeof bound === "number") eventArea.drag.minimumX = Qt.binding(function () {return (bound - offset)*zoomFactor - width/2.0;});
            else eventArea.drag.minimumX = Qt.binding(function () {return bound.x+bound.width;});
        }
    }
    //Note: if bound is a number that changes, bear in mind that this only sets the current value of bound, even though it's a binding. -Erik W

    function setRightBound(bound) {
        if (bound != undefined) {
            if (typeof bound === "number") eventArea.drag.maximumX = Qt.binding(function () {return (bound - offset)*zoomFactor - width/2.0;});
            else eventArea.drag.maximumX = Qt.binding(function () {return bound.x-width;});
        }
    }

    function updateUtc() {
        event.primaryUtc = ((x+width/2.0)/zoomFactor)+offset;
    }

    function rebindX() {
        x = Qt.binding(function () {if (event!=null) return (event.primaryUtc-offset)*zoomFactor - width/2; else return 0;});
    }
}
