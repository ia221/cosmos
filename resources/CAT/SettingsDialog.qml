import QtQuick 2.2
import QtQuick.Window 2.0
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1

Window {
    id: dialog
    width: 300
    height: 150
    title: "Settings"
    modality: Qt.WindowModal
    flags: Qt.Dialog

    property QtObject settingsObj

    onSettingsObjChanged: {
        //Copy the settings onto the ui controls:
        isoTimeBox.checked = settingsObj.iso8601Time;
    }

    Column {
        id: column1
        anchors.bottom: row1.top
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.margins: 4
        spacing: 4

        Label {
            id: label1
            text: "Units"
        }

        CheckBox {
            id: isoTimeBox
            text: "Use ISO 8601 Time"
            checked: true
        }
    }

    RowLayout {
        id: row1
        spacing: 10
        height: 35
        anchors.right: parent.right
        anchors.rightMargin: 4
        anchors.left: parent.left
        anchors.leftMargin: 4
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 4

        Button {
            id: applybutton
            text: "Apply"
            Layout.alignment: Qt.AlignRight
            onClicked: {
                //Copy the state of the ui controls back into the settings object:
                settingsObj.iso8601Time = isoTimeBox.checked;
                dialog.close();
            }
        }

        Button {
            id: cancelbutton
            text: "Cancel"
            Layout.alignment: Qt.AlignLeft
            onClicked: dialog.close();
        }
    }
}
