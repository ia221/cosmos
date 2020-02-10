import QtQuick 2.2
import QtQuick.Controls 1.2

import COSMOS 1.0

Item {
    property QtObject eventList: undefined
    property var loadDlg: undefined
    property var saveDlg: undefined
    property alias editable: editableBox.checked
    property QtObject cmdDict: null
    property QtObject evtDict: null

    Row {
        id: buttonRow
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 25
        spacing: 5
        anchors.margins: 5

        Button {
            id: loadButton
            enabled: loadDlg!=undefined
            text: "Load..."
            onClicked: loadDlg.open()
        }
        Button {
            id: saveButton
            enabled: saveDlg!=undefined
            text: "Save..."
            onClicked: saveDlg.open()
        }
        Button {
            id: addButton
            text: "Add Event"
            enabled: editable
            menu: Menu {
                DictionaryMenu {
                    title: "Command"
                    visible: cmdDict!=undefined
                    dictionary: cmdDict
                    targetList: eventList
                }
                DictionaryMenu {
                    title: "Event"
                    visible: evtDict!=undefined
                    dictionary: evtDict
                    targetList: eventList
                }
                MenuItem {
                    text: "Blank"
                    onTriggered: {
                        createNewEvent(undefined, eventList);
                    }
                }
            }
        }
        CheckBox {
            id: editableBox
            text: "Editable"
        }
    }

    TableView {
        id: table
        anchors.top: buttonRow.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Component {
            id: utcDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        if (settings.iso8601Time) return CommandAssembler.isoFromUtc(eventList.at(styleData.value).utc);
                        else return eventList.at(styleData.value).utc.toFixed(7);
                    }
                    color: !(eventList.at(styleData.value).flag & Event.FlagActual) ? "black" : "gray"
                }
            }
        }
        Component {
            id: utcexecDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        if (settings.iso8601Time) return CommandAssembler.isoFromUtc(eventList.at(styleData.value).utcexec);
                        else return eventList.at(styleData.value).utcexec.toFixed(7);
                    }
                    color: (eventList.at(styleData.value).flag & Event.FlagActual) ? "black" : "gray"
                }
            }
        }
        Component {
            id: nodeDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).node
                }
            }
        }
        Component {
            id: nameDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).name
                }
            }
        }
        Component {
            id: userDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).user
                }
            }
        }
        Component {
            id: enterExitDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: {
                        if (eventList.at(styleData.value).flag & (Event.FlagPair | Event.FlagExit)) {
                            if (eventList.at(styleData.value).flag & Event.FlagExit) return "EXIT";
                            else return "ENTER";
                        } else return "";
                    }
                    color: eventList.at(styleData.value).orphaned ? "red" : "black"
                }
            }
        }
        Component {
            id: typeDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: local.getTypeName(eventList.at(styleData.value).type)
                }
            }
        }
        /*Component {
            id: valueDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).value
                }
            }
        }
        Component {
            id: dataDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).data
                }
            }
        }
        Component {
            id: conditionDelegate
            Item {
                clip: true
                Label {
                    anchors.verticalCenter: parent.verticalCenter
                    text: eventList.at(styleData.value).condition
                }
            }
        }*/

        model: eventList ? eventList.length : 0
        selectionMode: SelectionMode.ExtendedSelection

        selection.onSelectionChanged: {
            if (!local.externalUpdate) {
                local.internalUpdate = true;
                for (var i=0; i<model; i++) eventList.at(i).selected = selection.contains(i);
                local.internalUpdate = false;
            }
        }

        MouseArea {
            id: commandQueueArea
            acceptedButtons: Qt.RightButton
            anchors.fill: parent

            onClicked: {
                mnu.popup();
            }

            Menu {
                id: mnu
                MenuItem {
                    text: "Copy" + (table.selection.count>1 ? " ("+table.selection.count+")" : "")
                    enabled: table.selection.count>0
                    onTriggered: {
                        clearCopyBuffer();
                        table.selection.forEach(local.copyByIndex);
                    }
                }
                MenuItem {
                    text: "Paste" + (copyBuffer.length>1 ? " ("+copyBuffer.length+")" : "")
                    enabled: copyBuffer.length>0
                    onTriggered: {
                        table.selection.clear();
                        for (var i=0; i<copyBuffer.length; i++) {
                            eventList.append(CommandAssembler.copyEvent(copyBuffer[i]));
                        }
                    }
                }
                MenuItem {
                    text: "Edit Event Properties..." + (table.selection.count>1 ? " ("+table.selection.count+")" : "")
                    enabled: table.selection.count>0
                    onTriggered: {
                        //if (commandQueueDisplay.selection.count<10) {
                        table.selection.forEach(local.dialogByIndex);
                        //} else //We should really think of a better option for that many events...
                    }
                }
                MenuItem {
                    text: "Delete" + (table.selection.count>1 ? " ("+table.selection.count+")" : "")
                    enabled: table.selection.count>0
                    onTriggered: {
                        table.selection.forEach(function (evtIdx) {local.deleteList.push(evtIdx);});
                        local.deleteList.reverse();
                        for (var i=0; i<local.deleteList.length; i++) {
                            Support.changeQObjectParent(eventList.at(local.deleteList[i]), null);
                            eventList.removeAt(local.deleteList[i]);
                        }
                        local.deleteList = new Array();
                    }
                }
            }
        }

        TableViewColumn {title: "UTC"; delegate: utcDelegate; width: 110}
        TableViewColumn {title: "UTC Executed"; delegate: utcexecDelegate; width: 110}
        TableViewColumn {title: "Name"; delegate: nameDelegate; width: 100}
        TableViewColumn {title: "Type"; delegate: typeDelegate; width: 70}
        TableViewColumn {title: "Node"; delegate: nodeDelegate; width: 100}
        TableViewColumn {title: "Pair"; delegate: enterExitDelegate; width: 33}

        QtObject {
            id: local
            property var windows: new Object()
            property var deleteList: new Array()
            property bool externalUpdate: false
            property bool internalUpdate: false
            property bool internalListUpdate: false

            function connectToSelectionUpdate(evt) {
                evt.selectedChanged.connect(externalSelectionUpdate);
            }

            function externalSelectionUpdate() {
                if (!internalUpdate) {
                    externalUpdate = true;
                    for (var i=0; i<eventList.length; i++) {
                        if (eventList.at(i).selected) table.selection.select(i);
                        else table.selection.deselect(i);
                    }
                    externalUpdate = false;
                }
            }

            function dialogByIndex(evtIdx) {
                var evt = eventList.at(evtIdx);
                openEventDialog(evt);
            }

            function copyByIndex(evtIdx) {
                var evt = eventList.at(evtIdx);
                var evt2 = CommandAssembler.copyEvent(evt);
                addToCopyBuffer(evt2);
            }

            function getTypeName(type) {
                switch (type) {
                case Event.TypePhysical: return "Physical";
                case Event.TypeLatA: return "LatA";
                case Event.TypeLatD: return "LatD";
                case Event.TypeLatMax: return "LatMax";
                case Event.TypeLatMin: return "LatMin";
                case Event.TypeApogee: return "Apogee";
                case Event.TypePerigee: return "Perigee";
                case Event.TypeUmbra: return "Umbra";
                case Event.TypePenumbra: return "Penumbra";
                case Event.TypeGS: return "GS";
                case Event.TypeGS5: return "GS5";
                case Event.TypeGS10: return "GS10";
                case Event.TypeGSMax: return "GSMax";
                case Event.TypeTarg: return "Targ";
                case Event.TypeTargMin: return "TargMin";
                case Event.TypeCommand: return "Command";
                case Event.TypeBus: return "Bus";
                case Event.TypeEPS: return "EPS";
                case Event.TypeADCS: return "ADCS";
                case Event.TypePayload: return "Payload";
                case Event.TypeSystem: return "System";
                case Event.TypeLog: return "Log";
                case Event.TypeMessage: return "Message";
                default: return "Unrecognized";
                }
            }
        }
    }
    onEventListChanged: {
        if (!local.internalListUpdate&&eventList) {
            eventList.itemAdded.connect(local.connectToSelectionUpdate)
            eventList.listChanged.connect(function () {local.internalListUpdate = true; eventListChanged(eventList); local.internalListUpdate = false;});
        }
    }

}
