import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1

import COSMOS 1.0 //So we can instantiate COSMOS classes

Rectangle {
    width: 300
    height: 400

    Text {
        id: text1
        x: 8
        y: 8
        width: 110
        height: 18
        text: qsTr("EPS - Summary")
        font.italic: true
        font.bold: true
        font.pixelSize: 14
    }

    Text {
        id: text2
        x: 8
        y: 39
        width: 24
        height: 15
        text: qsTr("Power:")
        font.pixelSize: 12
    }

    TextField {
        id: textField1
        x: 60
        y: 36
        readOnly: true
        placeholderText: qsTr("0.0")
        text: pow.floatValue.toFixed(5)
        COSMOSDatum {
            id: pow
            datumName: "node_powgen"
        }
    }

    Text {
        id: text3
        x: 9
        y: 70
        width: 239
        height: 45
        text: qsTr("For some reason the panels weren't working, so I used tsens, which doesn't' really make sense for EPS but it's still an effective demo.")
        wrapMode: Text.WordWrap
        font.pixelSize: 12
    }

    colorbar {
        x: 9
        y: 137
        width: 40
        height: 50
        barColor: "yellow"
        fraction: tsen1.floatValue/350.0

        COSMOSDatum {
            id: tsen1
            datumName: "device_tsen_temp_001"
        }
    }

    colorbar {
        x: 64
        y: 137
        width: 40
        height: 50
        barColor: "yellow"
        fraction: tsen2.floatValue/350.0

        COSMOSDatum {
            id: tsen2
            datumName: "device_tsen_temp_002"
        }
    }

    colorbar {
        x: 119
        y: 137
        width: 40
        height: 50
        barColor: "yellow"
        fraction: tsen3.floatValue/350.0

        COSMOSDatum {
            id: tsen3
            datumName: "device_tsen_temp_003"
        }
    }

    colorbar {
        x: 174
        y: 137
        width: 40
        height: 50
        barColor: "yellow"
        fraction: tsen4.floatValue/350.0

        COSMOSDatum {
            id: tsen4
            datumName: "device_tsen_temp_004"
        }
    }

}
