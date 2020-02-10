import QtQuick 2.2
import COSMOS 1.0

Rectangle {
    height: parent.height
    anchors.verticalCenter: parent.verticalCenter

    property EventHandle enterEvent
    property EventHandle exitEvent

    radius: local.active ? 2 : 0
    color: local.editable&&(pairArea.containsMouse||pairArea.pressed) ? (local.active ? Qt.lighter(local.baseColor, 1.5) : local.baseColor) : (local.active ? local.baseColor : "#00000000")

    QtObject {
        id: local
        property color baseColor: "#0000ff"
        property bool active: true //The idea was that pairs where the exit event comes before the enter would still be draggable, but wouldn't be filled in.
                                   //I'm not sure I'll use this feature. -ErikW
        property bool editable: true

        function initEventPair() {
            if (enterEvent&&exitEvent) {
                editable = Qt.binding(function () {if (enterEvent) return enterEvent.editable;});
                if (exitEvent.x<enterEvent.x) {
                    anchors.left = exitEvent.horizontalCenter;
                    anchors.right = enterEvent.horizontalCenter;
                    enterEvent.setLeftBound(exitEvent);
                    exitEvent.setRightBound(enterEvent);
                    active = false;
                    baseColor = "#60888888";
                } else {
                    anchors.left = enterEvent.horizontalCenter;
                    anchors.right = exitEvent.horizontalCenter;
                    exitEvent.setLeftBound(enterEvent);
                    enterEvent.setRightBound(exitEvent);
                    active = true;
                    baseColor = Qt.binding(function () {if (enterEvent) return editable?enterEvent.baseColor:Qt.tint(enterEvent.baseColor, "#70a0a0a0"); else return "blue";});
                }
            }
        }
    }

    MouseArea {
        id: pairArea
        cursorShape: if (local.editable) pairArea.pressed ? "ClosedHandCursor" : "OpenHandCursor"
        anchors.fill: parent
        drag.target: if (local.editable) parent
        drag.axis: Drag.XAxis

        drag.onActiveChanged: {
            if (drag.active) {
                parent.anchors.left = undefined;
                parent.anchors.right = undefined;
                if (enterEvent) {
                    enterEvent.anchors.horizontalCenter = local.active ? parent.left : parent.right;
                    enterEvent.hilighted = true;
                }
                if (exitEvent) {
                    exitEvent.anchors.horizontalCenter = local.active ? parent.right : parent.left;
                    exitEvent.hilighted = true;
                }
            } else {
                if (enterEvent) {
                    enterEvent.anchors.horizontalCenter = undefined;
                    if (local.active) parent.anchors.left = enterEvent.horizontalCenter;
                    else parent.anchors.right = enterEvent.horizontalCenter;
                    enterEvent.updateUtc();
                    enterEvent.rebindX();
                    enterEvent.hilighted = false;
                }
                if (exitEvent) {
                    exitEvent.anchors.horizontalCenter = undefined;
                    if (local.active) parent.anchors.right = exitEvent.horizontalCenter;
                    else parent.anchors.left = exitEvent.horizontalCenter;
                    exitEvent.updateUtc();
                    exitEvent.rebindX();
                    exitEvent.hilighted = false;
                }
            }
        }
    }

    onEnterEventChanged: local.initEventPair()
    onExitEventChanged: local.initEventPair()

    function setLeftBound(bound) {
        if (bound != undefined) {
            if (typeof bound === "number") pairArea.drag.minimumX = Qt.binding(function () {return (bound - offset)*zoomFactor;});
            else pairArea.drag.minimumX = Qt.binding(function () {return bound.x + bound.width + 5;}); //assuming 'bound' is another EventPair object
        }
    }

    function setRightBound(bound) {
        if (bound != undefined) {
            if (typeof bound === "number") pairArea.drag.maximumX = Qt.binding(function () {return (bound - offset)*zoomFactor - width;});
            else pairArea.drag.maximumX = Qt.binding(function () {return bound.x - pairArea.width - 5;}); //assuming 'bound' is another EventPair object
        }
    }
}
