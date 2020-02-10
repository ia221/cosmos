import QtQuick 2.2
import QtQuick.Window 2.1
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

import COSMOS 1.0

Window {
    id: dialog
    width: 500
    height: 300
    title: "Event Properties"

    property Event event

    TabView {
        id: tabs
        anchors.fill: parent
        Tab {
            id: primaryProperties
            title: "Primary Properties"

            Item {

                Row {
                    id: row1
                    x: 6
                    y: 8
                    width: 158
                    height: 20

                    Label {
                        id: label1
                    text: "Name "
                    }

                    TextField {
                        id: nameField
                        property bool internalChange: false
                        onTextChanged: {
                            if (event!=undefined&&!internalChange) event.name = text;
                        }
                        onEditingFinished: refresh();
                        function refresh() {
                            if (event!=undefined) {
                                internalChange = true;
                                text = event.name;
                                internalChange = false;
                            }
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }

                }
                Row {
                    id: row2
                    x: 171
                    y: 9
                    width: 155
                    height: 19

                    Label {
                        id: label2
                        text: "Node "
                    }

                    TextField {
                        id: nodeField
                        property bool internalChange: false
                        onTextChanged: {
                            if (event!=undefined&&!internalChange) event.node = text;
                        }
                        onEditingFinished: refresh();
                        function refresh() {
                            if (event!=undefined) {
                                internalChange = true;
                                text = event.node;
                                internalChange = false;
                            }
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                }
                Row {
                    id: row3
                    x: 333
                    y: 8
                    width: 154
                    height: 20

                    Label {
                        id: label3
                        text: "User "
                    }

                    TextField {
                        id: userField
                        property bool internalChange: false
                        onTextChanged: {
                            if (event!=undefined&&!internalChange) event.user = text;
                        }
                        onEditingFinished: refresh();
                        function refresh() {
                            if (event!=undefined) {
                                internalChange = true;
                                text = event.user;
                                internalChange = false;
                            }
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                }
                Row {
                    id: row4
                    x: 8
                    y: 37
                    width: 189
                    height: 81
                    spacing: 5

                    Label {
                        id: label4
                        width: 45
                        text: "UTC "
                        horizontalAlignment: Text.AlignLeft
                    }

                    Column {
                        id: column1
                        width: 137
                        height: 67
                        spacing: 5

                        TextField {
                            id: utcField
                            x: 0
                            width: 95
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.utc = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.utc.toFixed(7);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.utcChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }

                        UtcEditor {
                            id: utcEdit
                            utc: event ? event.utc : 0
                            Component.onCompleted: utcEdit.utcEdited.connect(setEvent);
                            function setEvent(newutc) {
                                if (event) event.utc = newutc;
                            }
                        }
                    }
                }
                Row {
                    id: row6
                    x: 8
                    y: 230
                    clip: true
                    width: 133
                    height: 22

                    Label {
                        id: label6
                        width: 50
                        text: "Type "
                    }

                    ComboBox {
                        id: comboBox1
                        width: 82
                        model: ["Physical", "LatA", "LatD", "LatMax", "LatMin", "Apogee",
                            "Perigee", "Umbra", "Penumbra", "GS", "GS5", "GS10", "GSMax",
                            "Targ", "TargMin", "Command", "Bus", "EPS", "ADCS", "Payload",
                            "System", "Log", "Message"]
                        property bool internalChange: false
                        onCurrentIndexChanged: {
                            if (event!=undefined&&!internalChange) {
                                event.type = idxToType(currentIndex);
                            }
                        }
                        function refresh() {
                            if (event!=undefined) {
                                internalChange = true;
                                currentIndex = typeToIdx(event.type);
                                internalChange = false;
                            }
                        }
                        function idxToType(idx) {
                            switch (idx) {
                            case 0: return Event.TypePhysical;
                            case 1: return Event.TypeLatA;
                            case 2: return Event.TypeLatD;
                            case 3: return Event.TypeLatMax;
                            case 4: return Event.TypeLatMin;
                            case 5: return Event.TypeApogee;
                            case 6: return Event.TypePerigee;
                            case 7: return Event.TypeUmbra;
                            case 8: return Event.TypePenumbra;
                            case 9: return Event.TypeGS;
                            case 10: return Event.TypeGS5;
                            case 11: return Event.TypeGS10;
                            case 12: return Event.TypeGSMax;
                            case 13: return Event.TypeTarg;
                            case 14: return Event.TypeTargMin;
                            case 15: return Event.TypeCommand;
                            case 16: return Event.TypeBus;
                            case 17: return Event.TypeEPS;
                            case 18: return Event.TypeADCS;
                            case 19: return Event.TypePayload;
                            case 20: return Event.TypeSystem;
                            case 21: return Event.TypeLog;
                            default: return Event.TypeMessage;
                            }
                        }
                        function typeToIdx(type) {
                            switch (type) {
                            case Event.TypePhysical: return 0;
                            case Event.TypeLatA: return 1;
                            case Event.TypeLatD: return 2;
                            case Event.TypeLatMax: return 3;
                            case Event.TypeLatMin: return 4;
                            case Event.TypeApogee: return 5;
                            case Event.TypePerigee: return 6;
                            case Event.TypeUmbra: return 7;
                            case Event.TypePenumbra: return 8;
                            case Event.TypeGS: return 9;
                            case Event.TypeGS5: return 10;
                            case Event.TypeGS10: return 11;
                            case Event.TypeGSMax: return 12;
                            case Event.TypeTarg: return 13;
                            case Event.TypeTargMin: return 14;
                            case Event.TypeCommand: return 15;
                            case Event.TypeBus: return 16;
                            case Event.TypeEPS: return 17;
                            case Event.TypeADCS: return 18;
                            case Event.TypePayload: return 19;
                            case Event.TypeSystem: return 20;
                            case Event.TypeLog: return 21;
                            case Event.TypeMessage: return 22;
                            default: return -1;
                            }
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                }

                GroupBox {
                    id: pairedBox
                    x: 8
                    y: 258
                    width: 111
                    height: 14
                    flat: true
                    checkable: true
                    title: "Paired"
                    property bool internalChange: false
                    onCheckedChanged: {
                        if (event!=undefined&&!internalChange) {
                            if (checked) event.flag = event.flag | Event.FlagPair; //Adds in the pair flag
                            else {
                                event.flag = event.flag & ~(Event.FlagPair | Event.FlagExit); //Subtracts the pair and exit flags
                                exitBox.refresh();
                            }
                        }
                    }
                    function refresh() {
                        if (event!=undefined) {
                            internalChange = true;
                            checked = event.flag & Event.FlagPair;
                            internalChange = false;
                        }
                    }
                    Component.onCompleted: {
                        refresh();
                        dialog.eventChanged.connect(refresh);
                    }

                    CheckBox {
                        id: exitBox
                        x: 60
                        y: -17
                        width: 37
                        height: 17
                        text: "Exit"
                        onClicked: {
                            if (event!=undefined) {
                                if (checked) event.flag = event.flag | Event.FlagExit; //Adds in the exit flag
                                else event.flag = event.flag & ~Event.FlagExit; //Subtracts the exit flag
                            }
                        }
                        function refresh() {
                            if (event!=undefined) checked = event.flag & Event.FlagExit;
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                }
                GroupBox {
                    id: actualBox
                    x: 2
                    y: 125
                    width: 201
                    height: 101
                    checked: false
                    checkable: true
                    title: "Actual"
                    property bool internalChange: false
                    onCheckedChanged: {
                        if (event!=undefined&&!internalChange) {
                            if (checked) event.flag = event.flag | Event.FlagActual; //Adds the actual flag
                            else {
                                event.flag = event.flag & ~Event.FlagActual; //Subtracts the actual flag
                                repeatBox.refresh();
                            }
                        }
                    }
                    function refresh() {
                        if (event!=undefined) {
                            internalChange = true;
                            checked = event.flag & Event.FlagActual;
                            internalChange = false;
                        }
                    }
                    Component.onCompleted: {
                        refresh();
                        dialog.eventChanged.connect(refresh);
                    }

                    Row {
                        id: row5
                        x: 0
                        y: 0
                        width: 189
                        height: 81
                        spacing: 5


                        Column {
                            id: column3
                            width: 45
                            height: 80

                            Label {
                                id: label5
                                width: 45
                                text: "UTC "
                                horizontalAlignment: Text.AlignLeft
                            }

                            Label {
                                id: label7
                                text: "Executed"
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                        Column {
                            id: column2
                            width: 137
                            height: 67
                            spacing: 5

                            TextField {
                                id: utcexecField
                                x: 0
                                width: 95
                                inputMethodHints: Qt.ImhFormattedNumbersOnly
                                property bool internalChange: false
                                onTextChanged: {
                                    if (event!=undefined&&!internalChange) {
                                        var num = Number(text);
                                        if (!isNaN(num)) event.utcexec = num;
                                    }
                                }
                                onEditingFinished: refresh();
                                function refresh() {
                                    if (event!=undefined) {
                                        internalChange = true;
                                        text = +event.utcexec.toFixed(7);
                                        internalChange = false;
                                    }
                                }
                                function init() {
                                    refresh();
                                    if (event!=undefined) dialog.event.utcexecChanged.connect(refresh);
                                }
                                Component.onCompleted: {
                                    init();
                                    dialog.eventChanged.connect(init);
                                }
                            }

                            UtcEditor {
                                id: utcexecEdit
                                utc: event ? event.utcexec : 0
                                Component.onCompleted: utcexecEdit.utcEdited.connect(setEvent);
                                function setEvent(newutc) {
                                    if (event) event.utcexec = newutc;
                                }
                            }
                        }
                    }
                }

                ToolButton {
                    id: colorButton
                    y: 235
                    x: 160

                    Rectangle {
                        z: -10
                        anchors.fill: parent
                        anchors.margins: 5
                        radius: 3
                        color: event ? event.color : "#00000000"
                        border.width: 1
                    }

                    Window {
                        id: colorChooser
                        width: 71
                        height: 69
                        color: "#77333333"
                        flags: Qt.Popup
                        modality: Qt.WindowModal

                        Grid {
                            anchors.fill: parent
                            anchors.margins: 2
                            columns: 3
                            spacing: 2

                            Rectangle {
                                id: color1; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "gray"
                                MouseArea {id: color1Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(1); colorChooser.close();}}
                                Rectangle {  radius: 3; anchors.fill: parent; visible: !color1Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color2; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "magenta"
                                MouseArea {id: color2Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(2); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color2Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color3; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "cyan"
                                MouseArea {id: color3Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(3); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color3Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color4; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "green"
                                MouseArea {id: color4Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(4); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color4Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color5; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "orange"
                                MouseArea {id: color5Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(5); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color5Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color6; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "yellow"
                                MouseArea {id: color6Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(6); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color6Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color7; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "red"
                                MouseArea {id: color7Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(7); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color7Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color8; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "brown"
                                MouseArea {id: color8Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(8); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color8Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                            Rectangle {
                                id: color9; width: colorButton.width-10; height: colorButton.height-10; radius: 3; color: "white"
                                MouseArea {id: color9Area; anchors.fill: parent; hoverEnabled: true; onClicked: {event.setColor(9); colorChooser.close();}}
                                Rectangle { radius: 3; anchors.fill: parent; visible: !color9Area.containsMouse;
                                    gradient: Gradient {
                                        GradientStop { position: 0; color: "#55ffffff"}
                                        GradientStop { position: 1; color: "#44333333"}
                                    }
                                }
                            }
                        }
                    }

                    onClicked: {
                        colorChooser.x = dialog.x + x - 19;
                        colorChooser.y = dialog.y + y;
                        var idx = (event.flag&Event.FlagColor)/Event.ScaleColor;
                        color1.border.width = idx==1;
                        color2.border.width = idx==2;
                        color3.border.width = idx==3;
                        color4.border.width = idx==4;
                        color5.border.width = idx==5;
                        color6.border.width = idx==6;
                        color7.border.width = idx==7;
                        color8.border.width = idx==8;
                        color9.border.width = idx==9;
                        colorChooser.show();
                    }

                }

                GroupBox {
                    id: conditionalBox
                    x: 209
                    y: 37
                    width: 278
                    height: 108
                    checkable: true
                    title: "Conditional"
                    property bool internalChange: false
                    onCheckedChanged: {
                        if (event!=undefined&&!internalChange) {
                            if (checked) event.flag = event.flag | Event.FlagConditional; //Adds the conditional flag
                            else {
                                event.flag = event.flag & ~(Event.FlagConditional | Event.FlagRepeat); //Subtracts the conditional and repeat flags
                                repeatBox.refresh();
                            }
                        }
                    }
                    function refresh() {
                        if (event!=undefined) {
                            internalChange = true;
                            checked = event.flag & Event.FlagConditional;
                            internalChange = false;
                        }
                    }
                    Component.onCompleted: {
                        refresh();
                        dialog.eventChanged.connect(refresh);
                    }

                    TextArea {
                        id: conditionArea
                        anchors.top: parent.top
                        anchors.left: parent.left
                        anchors.right: parent.right
                        anchors.bottom: repeatBox.top
                        wrapMode: TextEdit.Wrap
                        property bool internalChange: false
                        onTextChanged: {
                            if (event!=undefined&&!internalChange) event.condition = text;
                        }
                        onActiveFocusChanged: refresh();
                        function refresh() {
                            if (event!=undefined) {
                                internalChange = true;
                                text = event.condition;
                                internalChange = false;
                            }
                        }
                        Label {
                            id: placeholder
                            x: 5
                            y: 5
                            text: "Condition"
                            color: "gray"
                            visible: conditionArea.text=="" && !conditionArea.activeFocus
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                    CheckBox {
                        id: repeatBox
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        width: 51
                        height: 17
                        text: "Repeat"
                        onClicked: {
                            if (event!=undefined) {
                                if (checked) event.flag = event.flag | Event.FlagRepeat; //Adds in the repeat flag
                                else event.flag = event.flag & ~Event.FlagRepeat; //Subtracts the repeat flag
                            }
                        }
                        function refresh() {
                            if (event!=undefined) checked = event.flag & Event.FlagRepeat;
                        }
                        Component.onCompleted: {
                            refresh();
                            dialog.eventChanged.connect(refresh);
                        }
                    }
                }
                Label {
                    id: label8
                    x: 215
                    y: 151
                    text: "Data"
                }
                TextArea {
                    id: dataArea
                    x: 215
                    y: 168
                    width: 272
                    height: 104
                    wrapMode: TextEdit.Wrap
                    property bool internalChange: false
                    onTextChanged: {
                        if (event!=undefined&&!internalChange) event.data = text;
                    }
                    onActiveFocusChanged: refresh();
                    function refresh() {
                        if (event!=undefined) {
                            internalChange = true;
                            text = event.data;
                            internalChange = false;
                        }
                    }
                    Label {
                        id: placeholder2
                        x: 5
                        y: 5
                        text: "Data"
                        color: "gray"
                        visible: dataArea.text=="" && !dataArea.activeFocus
                    }
                    Component.onCompleted: {
                        refresh();
                        dialog.eventChanged.connect(refresh);
                    }
                }
            }

        }

        Tab {
            id: resourceProperties
            title: "Resource Properties"
            anchors.margins: 10

            Item {
                GridLayout {
                    anchors.fill: parent
                    columnSpacing: 50
                    rowSpacing: 50
                    columns: 2

                    Row {
                        id: row11
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label9
                            width: 120
                            text: "Initial Time Consumed"
                        }

                        TextField {
                            id: dtimeField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.dtime = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = event.dtime;
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.dtimeChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row12
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label10
                            width: 145
                            text: "Continuous Time Consumed"
                        }

                        TextField {
                            id: ctimeField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.ctime = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = event.ctime;
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.ctimeChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row13
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label11
                            width: 120
                            text: "Initial Energy Consumed"
                        }

                        TextField {
                            id: denergyField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.denergy = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.denergy.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.denergyChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row14
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label12
                            width: 145
                            text: "Continuous Energy Consumed"
                        }

                        TextField {
                            id: cenergyField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.cenergy = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.cenergy.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.cenergyChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row15
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label13
                            width: 120
                            text: "Initial Mass Consumed"
                        }

                        TextField {
                            id: dmassField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.dmass = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.dmass.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.dmassChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row16
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label14
                            width: 145
                            text: "Continuous Mass Consumed"
                        }

                        TextField {
                            id: cmassField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.cmass = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.cmass.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.cmassChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row17
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label15
                            width: 120
                            text: "Initial Bytes Consumed"
                        }

                        TextField {
                            id: dbytesField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.dbytes = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.dbytes.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.dbytesChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                    Row {
                        id: row18
                        x: 53
                        y: 60
                        width: 198
                        height: 21
                        spacing: 3

                        Label {
                            id: label16
                            width: 145
                            text: "Continuous Bytes Consumed"
                        }

                        TextField {
                            id: cbytesField
                            width: 60
                            inputMethodHints: Qt.ImhFormattedNumbersOnly
                            property bool internalChange: false
                            onTextChanged: {
                                if (event!=undefined&&!internalChange) {
                                    var num = Number(text);
                                    if (!isNaN(num)) event.cbytes = num;
                                }
                            }
                            onEditingFinished: refresh();
                            function refresh() {
                                if (event!=undefined) {
                                    internalChange = true;
                                    text = +event.cbytes.toPrecision(8);
                                    internalChange = false;
                                }
                            }
                            function init() {
                                refresh();
                                if (event!=undefined) dialog.event.cbytesChanged.connect(refresh);
                            }
                            Component.onCompleted: {
                                init();
                                dialog.eventChanged.connect(init);
                            }
                        }
                    }
                }
            }
        }

        Tab {
            id: jsonText
            title: "Event JSON String"

            TextArea {
                anchors.fill: parent
                wrapMode: TextEdit.Wrap
            }
        }
    }
}
