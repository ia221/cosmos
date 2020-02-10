import QtQuick 2.2
import QtQuick.Controls 1.1

Menu {
    id: mnu
    title: "Dictionary"

    property QtObject dictionary: undefined
    property QtObject targetList: undefined
    property bool placeAtCursor: false

    Instantiator {
        model: dictionary ? dictionary.length : 0
        MenuItem {
            text: dictionary ? dictionary.at(index).name : ""
            onTriggered: {
                if (targetList&&dictionary) {
                    var evt = placeAtCursor ? CommandAssembler.copyToUtc(dictionary.at(index), hoverUtc) : CommandAssembler.copyEvent(dictionary.at(index));
                    targetList.append(evt);
                    openEventDialog(evt);
                }
            }
        }
        onObjectAdded: mnu.insertItem(index, object)
        onObjectRemoved: mnu.removeItem(object)
    }
}
