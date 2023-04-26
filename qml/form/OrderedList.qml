import QtQuick 2.13
import QtQml.Models 2.1
import QtQuick.Controls 2.4
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.11
import "../../js/data.js" as OP

//![0]
GroupBox {
	id: root
	property var modelsKey
	property var itemList: OP.get(storageConfig, modelsKey)
	property string text
	onItemListChanged: {
		listModel.clear()
		itemList.forEach(el => {
							 listModel.append({
												  "textValue": el
											  })
						 })
	}
	ListModel {
		id: listModel
	}
	width: 300
	contentHeight: 200
	property int selectedIndex
	signal setChanges(var newOrder)
	function applyChanges() {
		const newValues = []
		for (var i = 0; i < visualModel.items.count; ++i)
			newValues.push(visualModel.items.get(i).model.textValue)
		setChanges(newValues)
	}
	Component {
		id: dragDelegate

		MouseArea {
			id: dragArea

			property bool held: false

			anchors {
				left: parent ? parent.left : undefined
				right: parent ? parent.right : undefined
			}
			height: content.height

			drag.target: held ? content : undefined
			drag.axis: Drag.YAxis

			onPressed: {
				held = true
				selectedIndex = index
			}
			onReleased: {
				held = false
				applyChanges()
			}

			Rectangle {
				id: content
				//![0]
				anchors {
					horizontalCenter: parent.horizontalCenter
					verticalCenter: parent.verticalCenter
				}
				width: dragArea.width
				height: column.implicitHeight + 4

				border.width: 1
				border.color: "lightsteelblue"

				color: dragArea.held
					   || selectedIndex === index ? "lightsteelblue" : "white"
				Behavior on color {
					ColorAnimation {
						duration: 100
					}
				}

				radius: 2
				//![1]
				Drag.active: dragArea.held
				Drag.source: dragArea
				Drag.hotSpot.x: width / 2
				Drag.hotSpot.y: height / 2
				//![1]
				states: State {
					when: dragArea.held

					ParentChange {
						target: content
						parent: root
					}
					AnchorChanges {
						target: content
						anchors {
							horizontalCenter: undefined
							verticalCenter: undefined
						}
					}
				}

				Column {
					id: column
					anchors {
						fill: parent
						margins: 2
					}

					Text {
						text: textValue
					}
				}
				//![2]
			}
			//![3]
			DropArea {
				anchors {
					fill: parent
					margins: 10
				}

				onEntered: {
					visualModel.items.move(
								drag.source.DelegateModel.itemsIndex,
								dragArea.DelegateModel.itemsIndex)
				}
			}

			//![3]
		}
	}
	//![2]
	//![4]
	DelegateModel {
		id: visualModel
		model: listModel
		delegate: dragDelegate
	}

	Dialog {
		id: popup

		property var valueModel
		property string valueName: "condition"
		width: 200
		height: 100
		Page {
			ColumnLayout {
				Text {
					text: "Insert new value for " + popup.valueName
				}
				TextField {
					id: textField
					width: 190
				}
			}
		}
		onAccepted: {
			popup.close()
			popup.valueModel.items.insert({
											  "textValue": textField.text
										  })
			applyChanges()
		}
		onRejected: {
			text: "Close"
			onClicked: popup.close()
		}
		standardButtons: StandardButton.Save | StandardButton.Cancel
	}
	ColumnLayout {
		anchors.fill: parent
		spacing: 20
		Text {
			text: root.text
		}
		ListView {
			id: view
			anchors {
				margins: 2
			}
			height: parent.height - 40 - controlRow.height
			width: parent.width
			clip: true
			model: visualModel
			spacing: 4
			cacheBuffer: 50
			ScrollBar.vertical: ScrollBar {
				id: vbar
				hoverEnabled: true
				active: hovered || pressed
				orientation: Qt.Vertical
				size: frame.height / content.height
				anchors.top: parent.top
				anchors.right: parent.right
				anchors.bottom: parent.bottom
			}
		}
		Row {
			id: controlRow
			anchors.bottom: parent.bottom
			Button {
				id: addButton
				text: "Add"
				onClicked: {
					popup.open()
					textField.text = ''
					popup.valueModel = visualModel
					popup.valueName = root.text
				}
			}
			Button {
				text: "Remove"
			}
		}
	}

	//![4]
	//![5]
} //![5]
