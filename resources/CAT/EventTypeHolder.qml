import QtQuick 2.2
import COSMOS 1.0

Item {
    id: typeHolder
    anchors.fill: parent

    property int type: 0x000000
    property var eventHandles: new Array()
    property int eventCount: eventHandles.length
    readonly property color typeColor: if (eventCount>0) return eventHandles[0].baseColor; else return "blue";

    Rectangle {
        id: startStateIndicator
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: -5 - 100
        anchors.left: parent.left
        radius: 2
        width: 0
    }

    Rectangle {
        id: endStateIndicator
        height: parent.height
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: -5
        anchors.right: parent.right
        radius: 2
        width: 0
    }

    QtObject {
        id: local
        property var eventPairs: new Array()
    }

    function initialize() {
        var lastEvent=null; //the most recent event (that isn't ignored as an orphan).
        var j;
        for (var i=0; i<eventHandles.length; i++) {
            if (eventHandles[i].event.flag & (Event.FlagPair | Event.FlagExit)) { //(although, really, the exit flag should only appear together with the pair flag)
                if (eventHandles[i].event.flag & Event.FlagExit) {
                    if (lastEvent==null) {
                        startStateIndicator.anchors.right = eventHandles[i].horizontalCenter;
                        var evt = eventHandles[i]; //this is neccessary, it changes how the following binding function is evaluated
                        startStateIndicator.color = Qt.binding(function () {if (evt) return evt.editable?evt.baseColor:Qt.tint(evt.baseColor, "#70a0a0a0"); else return "blue";});
                        lastEvent = eventHandles[i];
                        eventHandles[i].event.orphaned = false;
                    } else if (!(lastEvent.event.flag & Event.FlagExit)) {
                        j = local.eventPairs.push(Qt.createQmlObject("import QtQuick 2.2; EventPair {}", typeHolder))-1;
                        local.eventPairs[j].enterEvent = lastEvent;
                        local.eventPairs[j].exitEvent = eventHandles[i];
                        //then set bounds....
                        lastEvent = eventHandles[i];
                        eventHandles[i].event.orphaned = false;
                    } else eventHandles[i].event.orphaned = true;
                } else {
                    if (lastEvent==null || (lastEvent.event.flag & Event.FlagExit)) {
                        lastEvent = eventHandles[i];
                        eventHandles[i].event.orphaned = false;
                    } else eventHandles[i].event.orphaned = true;
                }
            } else eventHandles[i].event.orphaned = false;
        }
        if (lastEvent!=null && !(lastEvent.event.flag & Event.FlagExit)) {
            endStateIndicator.anchors.left = lastEvent.horizontalCenter;
            endStateIndicator.color = Qt.binding(function () {if (lastEvent) return lastEvent.editable?lastEvent.baseColor:Qt.tint(lastEvent.baseColor, "#70a0a0a0"); else return "blue";});
        }
        eventCount = eventHandles.length;
    }

    function clearEventHandles() {
        //Disconnect the edge state indicators and move them off screen
        startStateIndicator.anchors.right = undefined;
        startStateIndicator.width = 0;
        endStateIndicator.anchors.left = undefined;
        endStateIndicator.width = 0;
        var i;
        //Destroy all the eventPairs & eventHandles and reinitialize their arrays.
        for (i=0; i<local.eventPairs.length; i++) local.eventPairs[i].destroy();
        local.eventPairs = new Array();
        for (i=0; i<eventHandles.length; i++) eventHandles[i].destroy();
        eventHandles = new Array();
    }
}
