import QtQuick 2.2
import QtQuick.Controls 1.1
import COSMOS 1.0

Item {
    id: lane

    property Item eventArea: evtArea

    Item {
        id: evtArea
        anchors.left: lblArea.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
    }

    Item {
        id: lblArea
        z: 50
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: 100
        clip: true

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.height
            height: parent.width
            rotation: 90

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#66000000"
                }

                GradientStop {
                    position: 1
                    color: "#ff000000"
                }
            }
        }
        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.height
            height: parent.width
            rotation: 90

            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#88808080"
                }

                GradientStop {
                    position: 1
                    color: "#884c4c4c"
                }
            }
        }

        Column {
            id: lblColumn
            anchors.fill: parent
            anchors.leftMargin: 5
            anchors.rightMargin: 5
        }

        Instantiator {
            model: evtArea.children
            Label {
                parent: lblColumn
                text: lblArea.typeNameFromType(model.type)
                color: model.typeColor
                visible: model.eventCount > 0
            }
        }

        function typeNameFromType(typ) {
            switch (typ) {
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
