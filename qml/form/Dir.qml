import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import Qt.labs.platform 1.1
import "../../js/data.js" as OP

RowLayout {
	property string text
	property var modelsKey
	property string address
	TextField {
		text: OP.get(storageConfig, modelsKey)
	}
	FolderDialog {
		id: browseDialog
	}
	Button {
		text: "browse"
		onClicked: {
			browseDialog.open()
		}
	}
}
