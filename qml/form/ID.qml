import QtQuick 2.0
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Styles 1.4
import "../../js/data.js" as OP

GroupBox {
	property string doc
	property string text
	property string modelsKey
	title: doc
	ColumnLayout {
		RowLayout {
			Text {
				text: 'ID Prefix'
			}
			TextField {
				text: OP.get(storageConfig, modelsKey).prefix
			}
		}
		RowLayout {
			Text {
				text: 'ID Length'
			}
			ComboBox {
				width: 200
				model: ["4", "5", "6", "7", "8"]
			}
		}
	}
}
