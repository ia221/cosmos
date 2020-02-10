import QtQuick 2.2

Rectangle {
    id: bar
    height: 15
    radius: 3
    gradient: Gradient {
        GradientStop {
            position: 0
            color: "#99000000"
        }

        GradientStop {
            position: 1
            color: "#b3949494"
        }
    }

    //Distance from top or left of page to top or left side of viewport
    property double distance: 0 //This gets bound externally, so it's strictly read-only in here.

    property double pageLength: 10.0 //These will probably be bound from
    property double viewLength: 1.0  //outside, so don't mess with them!
    //property double scrollSpeed: 1 //how quickly distance changes in response to the scroll wheel
    //^Eventually I'll implement this, I promise!

    signal distChangedInternal(double dist)

    Rectangle {
        id: button
        anchors.verticalCenter: bar.verticalCenter
        width: viewLength>=pageLength ? bar.width-2 : ((viewLength/pageLength)*(bar.width-2)>20 ? (viewLength/pageLength)*(bar.width-2) : 20)
        height: parent.height-2
        radius: 5
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#c7c7c7"
            }

            GradientStop {
                position: 1
                color: "#515151"
            }
        }

        property double workingDist: distance //A working copy of distance
        property bool insideSet: false //distance was just set from inside

        onWorkingDistChanged: {
            if (insideSet) {
                distChangedInternal(workingDist);
                insideSet = false;
            }
        }

        x: xFromDist()

        MouseArea {
            id: buttonArea
            anchors.fill: parent
            drag.target: parent
            drag.axis: Drag.XAxis
            drag.minimumX: 1
            drag.maximumX: bar.width-1 - button.width

            drag.onActiveChanged: {
                if (drag.active) {
                    parent.x = parent.x; //breaks the old binding (would lead to binding loop on next line)
                    button.workingDist = Qt.binding(function () {button.insideSet = true; return parent.distFromX();});
                } else {
                    button.workingDist = Qt.binding(function () {return distance;}); //breaks the old binding (would lead to binding loop on next line)
                    parent.x = Qt.binding(parent.xFromDist);
                }
            }
        }

        function distFromX() {
            if (parent.width-2 - width <= 0) return 0;
            else return (pageLength-viewLength)*(x-1) < 0 ? 0 : (pageLength-viewLength)*((x-1)/(parent.width-2 - width));
        }

        function xFromDist() {
            if (pageLength-viewLength<=0) return 1;
            else return (workingDist/(pageLength-viewLength))*(parent.width-2 - width) + 1;
        }

        function keepInBounds() {
            if (viewLength <= 0) return; //some odd glitch causes the width of the timeline (which viewLength is bound to) to be set to 0 briefly.
            if (x+button.width>bar.width-1) {
                //break the appropriate binding
                if (buttonArea.drag.active) workingDist = workingDist;
                else x = x;
                button.insideSet = true;
                if (pageLength-viewLength<0) workingDist = 0;
                else workingDist = pageLength-viewLength;
                //re-establish the appropriate binding
                if (buttonArea.drag.active) workingDist = Qt.binding(function () {button.insideSet = true; return distFromX();});
                else {
                    workingDist = Qt.binding(function () {return distance;});
                    x = Qt.binding(xFromDist);
                }
            } if (x<1) {
                //break the appropriate binding
                if (buttonArea.drag.active) workingDist = workingDist;
                else x = x;
                button.insideSet = true;
                workingDist = 0;
                //re-establish the appropriate binding
                if (buttonArea.drag.active) workingDist = Qt.binding(function () {button.insideSet = true; return distFromX();});
                else {
                    workingDist = Qt.binding(function () {return distance;});
                    x = Qt.binding(xFromDist);
                }
            }
        }
    }

    Component.onCompleted: {
        pageLengthChanged.connect(button.keepInBounds);
        viewLengthChanged.connect(button.keepInBounds);
    }

}
