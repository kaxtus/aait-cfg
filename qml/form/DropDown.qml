import QtQuick 2.0
import QtQuick.Controls 2.4

ComboBox {
	id: dropDown
	property string modelkey

	selectTextByMouse: true
	displayText: currentIndex === -1 ? "Select Value" : currentText

	onActivated: {
	}
}
