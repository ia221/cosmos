import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import COSMOS 1.0

Item {
    property double offset: startUtc //In seconds
    property double zoomLevel: 2.0 //Determines the zoomFactor
    property double zoomFactor: 100*Math.pow(10.0, zoomLevel) //The actual factor to multiply event positions by
    property double startUtc: CommandAssembler.minUtc != Number.POSITIVE_INFINITY ? CommandAssembler.minUtc-0.005 : 0;
    property double endUtc: CommandAssembler.maxUtc != Number.NEGATIVE_INFINITY ? CommandAssembler.maxUtc+0.005 : 1;

    property double hoverUtc: xToUtc(marker.x);

    property var lists: new Array()
    property var lanes: new Array()
    property var borders: new Array()

    Rectangle {
        id: timeDisplay
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 25
        border.color: "gray"
        border.width: 1
        radius: 3
        color: "black"

        Text {
            id: dateReadout
            height: parent.height/2
            y: 0
            x: 100+marker.x-width/2>0 ? (100+marker.x+width/2<timeDisplay.width ? 100+marker.x-width/2 : timeDisplay.width-width) : 0

            text: CommandAssembler.dateStringFromUtc(hoverUtc)
            visible: timelineArea.containsMouse && settings.iso8601Time
            font.family: "Helvetica"
            font.pixelSize: 11
            color: "#23fa00"
        }

        Text {
            id: timeReadout
            height: settings.iso8601Time ? parent.height/2 : parent.height
            y: settings.iso8601Time ? 10 : 0
            x: 100+marker.x-width/2>0 ? (100+marker.x+width/2<timeDisplay.width ? 100+marker.x-width/2 : timeDisplay.width-width) : 0

            text: settings.iso8601Time ? CommandAssembler.timeStringFromUtc(hoverUtc) : hoverUtc.toFixed(7)
            visible: timelineArea.containsMouse
            font.family: "Helvetica"
            font.pixelSize: settings.iso8601Time ? 14 : 23
            color: "#23fa00"
        }

        Rectangle {
            id: reflection
            anchors.fill: parent
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#2bffffff"
                }

                GradientStop {
                    position: 0.457
                    color: "#4cffffff"
                }

                GradientStop {
                    position: 0.639
                    color: "#00ffffff"
                }

                GradientStop {
                    position: 0.983
                    color: "#2bffffff"
                }
            }
        }
    }

    TimelineScrollBar {
        id: scrollbar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        viewLength: timeline.width/zoomFactor
        pageLength: endUtc-startUtc
        distance: offset-startUtc
    }

    Rectangle {
        id: timelineBkg
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: timeDisplay.bottom
        anchors.bottom: scrollbar.top
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#333333"
            }

            GradientStop {
                position: 0.265
                color: "#1e1e1e"
            }

            GradientStop {
                position: 0.659
                color: "#1f1f1f"
            }

            GradientStop {
                position: 1
                color: "#333333"
            }
        }

        Item {
            id: timeline
            anchors.fill: parent
            anchors.leftMargin: 100

            ColumnLayout {
                id: layout
                anchors.fill: parent
                anchors.leftMargin: -100
                spacing: 0
            }

            Component.onCompleted: {
                //Make the event lanes:
                for (var i=0; i<5; i++) {
                    if (i>0) {
                        borders.push(Qt.createQmlObject("import QtQuick 2.2; Rectangle {color: 'gray'}", layout));
                        borders[i-1].Layout.fillWidth = borders[i-1].Layout.fillHeight = true;
                        borders[i-1].Layout.maximumHeight = 1;
                    }
                    lanes.push(Qt.createQmlObject("import QtQuick 2.2; EventLane {}", layout));
                    lanes[i].Layout.fillWidth = lanes[i].Layout.fillHeight = true;
                }
                //Make the timeline list holders (for the 3 different lists)
                for (i=0; i<3; i++) {
                    lists.push(Qt.createQmlObject("import QtQuick 2.2; EventListHolder {}", timeline));
                    lists[i].lanes = lanes;
                    switch (i) {
                    case 0:
                        lists[i].editable = Qt.binding(function () {return queueEditable;});
                        CommandAssembler.commandQueueChanged.connect(lists[i].reinitializeTypes);
                        lists[i].eventList = CommandAssembler.commandQueue;
                        break;
                    case 1:
                        lists[i].editable = Qt.binding(function () {return projectionEditable;});
                        CommandAssembler.projectedChanged.connect(lists[i].reinitializeTypes);
                        lists[i].eventList = CommandAssembler.projected;
                        break;
                    default:
                        lists[i].editable = Qt.binding(function () {return archiveEditable;});
                        CommandAssembler.archivalChanged.connect(lists[i].reinitializeTypes);
                        lists[i].eventList = CommandAssembler.archival;
                        break;
                    }
                    lists[i].reinitializeTypes();
                }
            }

            Rectangle {
                id: marker
                x: utcToX(startUtc-1)
                y: 0
                width: 1
                height: timeline.height
                color: "#23fa00"
                visible: timelineArea.containsMouse
            }
        }
    }

    MouseArea {
        id: timelineArea
        z: -5
        acceptedButtons: Qt.RightButton
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: scrollbar.top
        anchors.leftMargin: 100
        hoverEnabled: true
        propagateComposedEvents: true

        property double minZoomLevel: Math.log(timeline.width/(100*(endUtc-startUtc)))/Math.LN10

        onMouseXChanged: {
            marker.x = mouse.x;
        }
        onMouseYChanged: {
            //do something here later maybe....
        }

        onClicked: mnu.popup();

        onWheel: {
            var temp = 0.0, temp2;
            if ((Math.abs(wheel.angleDelta.x) < Math.abs(wheel.angleDelta.y))&&!(wheel.modifiers & Qt.ShiftModifier)) {
                temp2 = offset + wheel.x/zoomFactor;
                temp = zoomLevel + wheel.angleDelta.y/2000.0;
                zoomLevel = temp>4.1 ? 4.1 : (temp<minZoomLevel ? minZoomLevel : temp);
                temp2 = temp2 - (wheel.x/zoomFactor);
                offset = temp2<startUtc ? startUtc : (temp2>(endUtc-(timeline.width/zoomFactor)) ? endUtc-(timeline.width/zoomFactor) : temp2);
            } else if(wheel.modifiers & Qt.ShiftModifier) {
                temp2 = offset - wheel.angleDelta.y/zoomFactor;
                offset = offset = temp2<startUtc ? startUtc : (temp2>(endUtc-(timeline.width/zoomFactor)) ? endUtc-(timeline.width/zoomFactor) : temp2);
            } else {
                temp2 = offset - wheel.angleDelta.x/zoomFactor;
                offset = offset = temp2<startUtc ? startUtc : (temp2>(endUtc-(timeline.width/zoomFactor)) ? endUtc-(timeline.width/zoomFactor) : temp2);
            }
            //Also there should be a zoom slider somewhere
        }

        Menu {
            id: mnu
            Menu {
                title: "New Command Event"
                visible: queueEditable
                DictionaryMenu {
                    title: "Command"
                    dictionary: CommandAssembler.commandDict
                    targetList: CommandAssembler.commandQueue
                    placeAtCursor: true
                }
                MenuItem {
                    text: "Blank"
                    onTriggered: {
                        createNewEvent(hoverUtc, CommandAssembler.commandQueue);
                    }
                }
                MenuItem {
                    text: "Paste" + (copyBuffer.length>1 ? " ("+copyBuffer.length+")" : "")
                    enabled: copyBuffer.length>0
                    onTriggered: {
                        var offset = hoverUtc - copyBuffer[0].primaryUtc;
                        for (var i=0; i<copyBuffer.length; i++) {
                            var pastedEvent = CommandAssembler.copyEvent(copyBuffer[i]);
                            pastedEvent.primaryUtc += offset;
                            CommandAssembler.commandQueue.append(pastedEvent);
                        }
                    }
                }
            }
            Menu {
                title: "New Projected Event"
                visible: projectionEditable
                DictionaryMenu {
                    title: "Command"
                    dictionary: CommandAssembler.commandDict
                    targetList: CommandAssembler.projected
                    placeAtCursor: true
                }
                DictionaryMenu {
                    title: "Event"
                    dictionary: CommandAssembler.eventDict
                    targetList: CommandAssembler.projected
                    placeAtCursor: true
                }
                MenuItem {
                    text: "Blank"
                    onTriggered: {
                        createNewEvent(hoverUtc, CommandAssembler.projected);
                    }
                }
                MenuItem {
                    text: "Paste" + (copyBuffer.length>1 ? " ("+copyBuffer.length+")" : "")
                    enabled: copyBuffer.length>0
                    onTriggered: {
                        var offset = hoverUtc - copyBuffer[0].primaryUtc;
                        for (var i=0; i<copyBuffer.length; i++) {
                            var pastedEvent = CommandAssembler.copyEvent(copyBuffer[i]);
                            pastedEvent.primaryUtc += offset;
                            CommandAssembler.projected.append(pastedEvent);
                        }
                    }
                }
            }
            Menu {
                title: "New Archival Event"
                visible: archiveEditable
                DictionaryMenu {
                    title: "Command"
                    dictionary: CommandAssembler.commandDict
                    targetList: CommandAssembler.archival
                    placeAtCursor: true
                }
                DictionaryMenu {
                    title: "Event"
                    dictionary: CommandAssembler.eventDict
                    targetList: CommandAssembler.archival
                    placeAtCursor: true
                }
                MenuItem {
                    text: "Blank"
                    onTriggered: {
                        createNewEvent(hoverUtc, CommandAssembler.archival);
                    }
                }
                MenuItem {
                    text: "Paste" + (copyBuffer.length>1 ? " ("+copyBuffer.length+")" : "")
                    enabled: copyBuffer.length>0
                    onTriggered: {
                        var offset = hoverUtc - copyBuffer[0].primaryUtc;
                        for (var i=0; i<copyBuffer.length; i++) {
                            var pastedEvent = CommandAssembler.copyEvent(copyBuffer[i]);
                            pastedEvent.primaryUtc += offset;
                            CommandAssembler.archival.append(pastedEvent);
                        }
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        scrollbar.distChangedInternal.connect(updateOffsetFromDistance);
    }

    function updateOffsetFromDistance(newDistance) {
        offset = newDistance+startUtc;
    }

    function xToUtc(xcoord) {
        return xcoord/zoomFactor + offset;
    }

    function utcToX(utcVal) {
        return (utcVal - offset)*zoomFactor;
    }
}
