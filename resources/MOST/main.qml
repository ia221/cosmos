import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1
import QtQuick.Dialogs 1.1

import COSMOS 1.0 //So we can instantiate COSMOS classes

ApplicationWindow {
    id: mainWindow
    width: 500
    height: 620
    title: "MOST"
    visible: true

    EpsSummary {
        x: 50
        y: 50
    }
}
