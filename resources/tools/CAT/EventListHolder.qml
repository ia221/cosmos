import QtQuick 2.2

import COSMOS 1.0

QtObject {
    property var lanes: new Array()
    property QtObject eventList: undefined
    property var eventTypes: new Array()
    property bool editable: true

    /*Creates all the EventHandles and sorts them into the correct EventTypeHolders,
      creating the necessary EventTypeHolders in the process via typeHolderIndex().*/
    function reinitializeTypes() {
        var i, j;
        //Erase all the old handles
        for (i=0; i<eventTypes.length; i++) {
            eventTypes[i].clearEventHandles();
        }
        //Make the EventTypeHolders and the EventHandles they contain.
        for (i=0; i<eventList.length; i++) {
            //create a handle for the new event and add it to the appropriate holder
            j = typeHolderIndex(eventList.at(i).type);
            eventTypes[j].eventHandles.push(Qt.createQmlObject("import QtQuick 2.2; EventHandle {}", eventTypes[j]));
            eventTypes[j].eventHandles[eventTypes[j].eventHandles.length-1].event = eventList.at(i);
        }
        //Initialize the type holders
        for (i=0; i<eventTypes.length; i++) {
            eventTypes[i].initialize();
        }
        setEditableState();
    }

    /*Returns the type holder index for the given type,
      creates a new type holder if one does not yet exist.*/
    function typeHolderIndex(currentType) {
        var typeFound = false; //We found no matching type.
        for (var j=0; j<eventTypes.length; j++) {
            if (eventTypes[j].type==currentType) {
                typeFound=true; //We've found the type we're looking for.
                break;
            }
        }
        if (!typeFound) { //If we didn't find the type we were looking for,
            //Assign the new type holder it its default parent lane
            var parentLane;
            switch (currentType) {
            case Event.TypePhysical:
            case Event.TypeLatA:
            case Event.TypeLatD:
            case Event.TypeLatMax:
            case Event.TypeLatMin:
            case Event.TypeApogee:
            case Event.TypePerigee:
            case Event.TypeUmbra:
            case Event.TypePenumbra:
                parentLane = lanes[0];
                break;
            case Event.TypeGS:
            case Event.TypeGS5:
            case Event.TypeGS10:
            case Event.TypeGSMax:
            case Event.TypeTarg:
            case Event.TypeTargMin:
                parentLane = lanes[1];
                break;
            case Event.TypeCommand:
            case Event.TypeBus:
            case Event.TypeEPS:
            case Event.TypeADCS:
            case Event.TypePayload:
            case Event.TypeSystem:
                parentLane = lanes[2];
                break;
            case Event.TypeLog:
                parentLane = lanes[3];
                break;
            case Event.TypeMessage:
                parentLane = lanes[4];
                break;
            default:
                parentLane = lanes[4];
                break;
            }
            //make a new type holder and add it to the array
            eventTypes.push(Qt.createQmlObject("import QtQuick 2.2; EventTypeHolder {}", parentLane.eventArea));
            eventTypes[j].type = currentType;
        }
        return j;
    }

    function setEditableState() {
        for (var i=0; i<eventTypes.length; i++) {
            eventTypes[i].z = editable ? 0 : -10;
            for (var j=0; j<eventTypes[i].eventHandles.length; j++) {
                eventTypes[i].eventHandles[j].editable = editable;
            }
        }
    }

    onEditableChanged: setEditableState();
}
