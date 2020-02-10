import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1

import COSMOS 1.0 //Import allows us to instantiate our own Events

ApplicationWindow {
    id: mainWindow
    visible: true
    width: 1055
    height: 600
    title: "Command Assembler"

    property bool queueEditable: true
    property bool projectionEditable: false
    property bool archiveEditable: false
    property bool commandDictEditable: true
    property bool eventDictEditable: true

    property var copyBuffer: new Array()

    menuBar: MenuBar {
        Menu {
            title: "Menu"
            MenuItem {
                text: "Settings"
                onTriggered: {
                    var comp = Qt.createComponent("SettingsDialog.qml");
                    var window = comp.createObject(mainWindow);
                    window.settingsObj = settings;
                    window.show();
                }
            }
            MenuItem {
                text: "Add New Event"
                onTriggered: createNewEvent();
            }
            MenuSeparator { }
            Menu {
                title: "Load"
                MenuItem {
                    text: "Load Event Dictionary"
                    onTriggered: loadEventDictDialog.open();
                }
                MenuItem {
                    text: "Load Command Dictionary"
                    onTriggered: loadCmdDictDialog.open();
                }
                MenuItem {
                    text: "Load Command Queue"
                    onTriggered: loadQueueDialog.open();
                }
                MenuItem {
                    text: "Load Archive"
                    onTriggered: loadArchivalDialog.open();
                }
            }
            Menu {
                title: "Save"
                MenuItem {
                    text: "Save Event Dictionary"
                    onTriggered: saveEvtDictDialog.open();
                }
                MenuItem {
                    text: "Save Command Dictionary"
                    onTriggered: saveCmdDictDialog.open();
                }
                MenuItem {
                    text: "Save Command Queue"
                    onTriggered: saveQueueDialog.open();
                }
                MenuItem {
                    text: "Save Projected Timeline"
                    onTriggered: saveProjectedDialog.open();
                }
                MenuItem {
                    text: "Save Archival Timeline"
                    onTriggered: saveArchiveDialog.open();
                }
            }
            MenuSeparator { }
            MenuItem {
                text: "Clear All"
                onTriggered: CommandAssembler.eraseQueue(); //need to do something about the dialogs and error messages....
            } //and I really don't understand why EventListDisplay tries to access out of range indicies when the length is set to zero.

            MenuItem {
                text: "Exit"
                onTriggered: Qt.quit();
            }
        }
    }

    FileDialog {
        id: loadEventDictDialog
        title: "Select Event Files"
        onAccepted: {
            var url;
            for (var i=0; i<fileUrls.length; i++) CommandAssembler.loadEventsFromFile(fileUrls[i], CommandAssembler.eventDict);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: loadCmdDictDialog
        title: "Select Event Files"
        onAccepted: {
            var url;
            for (var i=0; i<fileUrls.length; i++) CommandAssembler.loadEventsFromFile(fileUrls[i], CommandAssembler.commandDict);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: loadQueueDialog
        title: "Select Event Files"
        onAccepted: {
            var url;
            for (var i=0; i<fileUrls.length; i++) CommandAssembler.loadEventsFromFile(fileUrls[i], CommandAssembler.commandQueue);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: loadArchivalDialog
        title: "Select Event Files"
        onAccepted: {
            var url;
            for (var i=0; i<fileUrls.length; i++) CommandAssembler.loadEventsFromFile(fileUrls[i], CommandAssembler.archival);
            close();
        }
        onRejected: close();
    }

    FileDialog {
        id: saveEvtDictDialog
        title: "Save Event Dictionary"
        selectExisting: false
        selectMultiple: false
        onAccepted: {
            CommandAssembler.saveEventsToFile(fileUrl, CommandAssembler.eventDict);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: saveCmdDictDialog
        title: "Save Command Dictionary"
        selectExisting: false
        selectMultiple: false
        onAccepted: {
            CommandAssembler.saveEventsToFile(fileUrl, CommandAssembler.commandDict);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: saveQueueDialog
        title: "Save Command Queue"
        selectExisting: false
        selectMultiple: false
        onAccepted: {
            CommandAssembler.saveEventsToFile(fileUrl, CommandAssembler.commandQueue);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: saveProjectedDialog
        title: "Save Projected Timeline"
        selectExisting: false
        selectMultiple: false
        onAccepted: {
            CommandAssembler.saveEventsToFile(fileUrl, CommandAssembler.projected);
            close();
        }
        onRejected: close();
    }
    FileDialog {
        id: saveArchiveDialog
        title: "Save Archival Timeline"
        selectExisting: false
        selectMultiple: false
        onAccepted: {
            CommandAssembler.saveEventsToFile(fileUrl, CommandAssembler.archival);
            close();
        }
        onRejected: close();
    }

    QtObject {
        id: settings
        property bool iso8601Time: true
    }

    CosmosTimeline {
        id: timeline
        x:0
        y:0
        width: parent.width
        height: 300
    }

    TabView {
        id: timelineLists
        x:0
        y:300
        width: parent.width/2
        height: parent.height-300

        Tab {
            title: "Command Queue"
            EventListDisplay {
                id: commandQueue
                focus: true
                eventList: CommandAssembler.commandQueue
                loadDlg: loadQueueDialog
                saveDlg: saveQueueDialog
                cmdDict: CommandAssembler.commandDict
                editable: queueEditable
                Component.onCompleted: {
                    editable = editable;
                    queueEditable = Qt.binding(function () {return editable;});
                }
            }
        }
        Tab {
            title: "Projected Events"
            EventListDisplay {
                id: projected
                focus: true
                eventList: CommandAssembler.projected
                saveDlg: saveProjectedDialog
                evtDict: CommandAssembler.eventDict
                editable: projectionEditable
                Component.onCompleted: {
                    editable = editable;
                    projectionEditable = Qt.binding(function () {return editable;});
                }
            }
        }
        Tab {
            title: "Archival Events"
            EventListDisplay {
                id: archival
                focus: true
                eventList: CommandAssembler.archival
                loadDlg: loadArchivalDialog
                saveDlg: saveArchiveDialog
                evtDict: CommandAssembler.eventDict
                editable: archiveEditable
                Component.onCompleted: {
                    editable = editable;
                    archiveEditable = Qt.binding(function () {return editable;});
                }
            }
        }
    }
    TabView {
        id: dictionaries
        x:timelineLists.width
        y:300
        width: parent.width/2
        height: parent.height-300

        Tab {
            title: "Command Dictionary"
            EventListDisplay {
                id: commandDict
                focus: true
                eventList: CommandAssembler.commandDict
                loadDlg: loadCmdDictDialog
                saveDlg: saveCmdDictDialog
                editable: commandDictEditable
                Component.onCompleted: {
                    editable = editable;
                    commandDictEditable = Qt.binding(function () {return editable;});
                }
            }
        }
        Tab {
            title: "Event Dictionary"
            EventListDisplay {
                id: eventDict
                focus: true
                eventList: CommandAssembler.eventDict
                loadDlg: loadEventDictDialog
                saveDlg: saveEvtDictDialog
                editable: eventDictEditable
                Component.onCompleted: {
                    editable = editable;
                    eventDictEditable = Qt.binding(function () {return editable;});
                }
            }
        }
    }

    QtObject {
        id: local
        property var dialogs: new Object()
    }

    function createNewEvent(utc, lst) {
        if (typeof utc === "undefined") utc = timeline.startUtc;
        var evt = Qt.createQmlObject("import QtQuick 2.2; import COSMOS 1.0; Event{}", CommandAssembler);
        evt.utc = utc;
        lst.append(evt);
        openEventDialog(evt);
    }

    function clearCopyBuffer() {
        for (var i=0; i<copyBuffer.length; i++) Support.changeQObjectParent(copyBuffer[i], null);
        copyBuffer = new Array();
    }

    function addToCopyBuffer(itm) {
        copyBuffer.push(itm);
        copyBufferChanged(copyBuffer); //otherwise we don't get a changed signal. (might not really matter...)
    }

    function openEventDialog(evt) {
        if (local.dialogs[evt]==undefined||local.dialogs[evt]==null) {
            var comp = Qt.createComponent("EventPropertiesDialog.qml");
            local.dialogs[evt] = comp.createObject(mainWindow);
            local.dialogs[evt].event = evt;
        }
        local.dialogs[evt].show();
    }

    function eventIdx(evt) {
        for (var i=0; i<CommandAssembler.commandQueue.length; i++) {
            if (CommandAssembler.commandQueue.at(i)==evt) return i;
        }
        return -1; //event wasn't found
    }
}
