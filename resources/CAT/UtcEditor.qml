import QtQuick 2.2
import QtQuick.Controls 1.1

Item {
    width: 135
    height: 50

    property double utc: -1 //Externally bound to the actual utc
    signal utcEdited (double newUtc)

    onUtcChanged: {
        if (!CommandAssembler) return;
        var date = CommandAssembler.mjdToCalendar(utc);
        utcYearBox.internalSet = true;
        utcMonthBox.internalSet = true;
        utcDayBox.internalSet = true;
        utcHourBox.internalSet = true;
        utcMinuteBox.internalSet = true;
        utcSecondBox.internalSet = true;

        utcYearBox.value = date.year;
        utcMonthBox.value = date.month;
        utcDayBox.value = date.day;
        utcHourBox.value = Math.floor(date.dayFraction*24);
        utcMinuteBox.value = Math.floor((date.dayFraction*24 - utcHourBox.value)*60);
        utcSecondBox.value = ((date.dayFraction*24*60)%1)*60;

        utcYearBox.internalSet = false;
        utcMonthBox.internalSet = false;
        utcDayBox.internalSet = false;
        utcHourBox.internalSet = false;
        utcMinuteBox.internalSet = false;
        utcSecondBox.internalSet = false;
    }

    QtObject {
        id: local
        function updateUtc() {
            utcEdited(CommandAssembler.calendarToMJD(
                          utcYearBox.value, utcMonthBox.value,
                          utcDayBox.value+(utcHourBox.value+
                          (utcMinuteBox.value+utcSecondBox.value/60)/60)/24));
        }
    }

    Column {
        id: column1
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        anchors.topMargin: 0
        anchors.fill: parent
        spacing: 5

        Row {
            id: row7
            width: 135
            height: 25
            spacing: 5

            SpinBox {
                id: utcYearBox
                width: 48
                maximumValue: 9999999
                minimumValue: -9999999
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        local.updateUtc();
                    }
                }
            }

            SpinBox {
                id: utcMonthBox
                minimumValue: 0
                maximumValue: 13
                value: 1
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        if (value>12) {
                            internalSet = true;
                            value = 1;
                            internalSet = false;
                            utcYearBox.value++; //Happy New Year!!!
                        } else if (value<1) {
                            internalSet = true;
                            value = 12;
                            internalSet = false;
                            utcYearBox.value--; //!!!raeY weN yppaH
                        } else {
                            local.updateUtc();
                        }
                    }
                }
            }

            SpinBox {
                id: utcDayBox
                minimumValue: 0
                maximumValue: 32
                value: 1
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        if (value>monthLength(utcMonthBox.value)) {
                            internalSet = true;
                            value = 1;
                            internalSet = false;
                            utcMonthBox.value++;
                        } else if (value<1) {
                            internalSet = true;
                            value = monthLength(utcMonthBox.value-1);
                            internalSet = false;
                            utcMonthBox.value--;
                        } else {
                            local.updateUtc();
                        }
                    }
                }

                function monthLength(month) {
                    switch (month) {
                    case 1: return 31;
                    case 2:
                        if (utcYearBox.value%4!=0) return 28;
                        else if (utcYearBox.value%100!=0) return 29;
                        else if (utcYearBox.value%400!=0) return 28;
                        else return 29;
                    case 3: return 31;
                    case 4: return 30;
                    case 5: return 31;
                    case 6: return 30;
                    case 7: return 31;
                    case 8: return 31;
                    case 9: return 30;
                    case 10: return 31;
                    case 11: return 30;
                    default: return 31;
                    }
                }
            }
        }
        Row {
            id: row8
            width: 135
            height: 25
            spacing: 5

            SpinBox {
                id: utcHourBox
                width: 35
                height: 20
                minimumValue: -1
                maximumValue: 24
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        if (value>23) {
                            internalSet = true;
                            value = 0;
                            internalSet = false;
                            utcDayBox.value++;
                        } else if (value<0) {
                            internalSet = true;
                            value = 23;
                            internalSet = false;
                            utcDayBox.value--;
                        } else {
                            local.updateUtc();
                        }
                    }
                }
            }

            SpinBox {
                id: utcMinuteBox
                minimumValue: -1
                maximumValue: 60
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        if (value>59) {
                            internalSet = true;
                            value = 0;
                            internalSet = false;
                            utcHourBox.value++;
                        } else if (value<0) {
                            internalSet = true;
                            value = 59;
                            internalSet = false;
                            utcHourBox.value--;
                        } else {
                            local.updateUtc();
                        }
                    }
                }
            }

            SpinBox {
                id: utcSecondBox
                width: 55
                decimals: 2
                minimumValue: -1
                maximumValue: 61
                property bool internalSet: false
                onValueChanged: {
                    if (!internalSet) {
                        if (value>=60) {
                            internalSet = true;
                            value = value%1;
                            internalSet = false;
                            utcMinuteBox.value++;
                        } else if (value<0) {
                            internalSet = true;
                            if (value%1 == 0) value = 59;
                            else value = 60 + (value%1);
                            internalSet = false;
                            utcMinuteBox.value--;
                        } else {
                            local.updateUtc();
                        }
                    }
                }
            }
        }
    }

}
