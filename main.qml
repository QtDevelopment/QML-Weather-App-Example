import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Layouts 1.1
import org.thepaffy.weatherapi 1.0

ApplicationWindow {
    visible: true
    width: 480
    height: 800
    title: qsTr("QML-Weather-App-Example")
    color: "green"

    WeatherAPI {
        id: weatherAPI
        url: "http://api.openweathermap.org/data/2.5/weather?q="
        onResultFinished: {
            cityName.text = xResult["name"];
            discription.text = xResult["weather"][0]["description"];
            temperature.text = Math.round(xResult["main"]["temp"] - 273.15) + " °C";
            humidity.text = xResult["main"]["humidity"] + " %";
        }
    }

    ColumnLayout {
        id: layout
        anchors.top: parent.top
        spacing: 0
        width: parent.width

        Text {
            id: cityName
            Layout.alignment: Qt.AlignCenter
            text: "Koblenz"
            font.pointSize: 20
            font.weight: Font.Bold
        }

        Text {
            id: discription
            Layout.alignment: Qt.AlignCenter
            text: "Bewölkt"
            font.pointSize: 18
        }

        Text {
            id: temperature
            Layout.alignment: Qt.AlignCenter
            text: "20 °C"
            font.pointSize: 18
        }

        Text {
            id: humidity
            Layout.alignment: Qt.AlignCenter
            text: "48.5 %"
            font.pointSize: 18
        }
    }

    ListModel {
        id: data

        ListElement {
            name: "Koblenz"
            searchString: "Koblenz,de"
        }

        ListElement {
            name: "München"
            searchString: "München,de"
        }

        ListElement {
            name: "Rom"
            searchString: "Rom,it"
        }
    }

    ListView {
        id: listView
        width: parent.width
        anchors.top: layout.bottom
        anchors.topMargin: 30
        anchors.bottom: parent.bottom

        signal clicked(int index);
        onClicked: {
            cityName.text = model.get(index).name;
            weatherAPI.requestWeather(model.get(index).searchString);
        }

        model: data
        delegate: Item {
            id: dataDelegate
            width: ListView.view.width
            height: text.paintedHeight
            Text {
                id: text
                anchors.fill: parent
                horizontalAlignment: Text.AlignHCenter
                text: name
                font.pointSize: 18
            }
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    dataDelegate.ListView.view.clicked(index);
                }
            }
        }
    }
}
