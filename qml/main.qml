import QtQuick 2.13
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.4
import QtQuick.Controls.Material 2.4
import QtQuick.Controls.Universal 2.4
import "./Layout"
import "./components"
import "../js/data.js" as OP

ApplicationWindow {
	id: history
	width: 1137
	height: 700
	visible: true
	title: qsTr("Settings")
	property int currentStackLayoutIndex: 0
	property var stackLayoutMap: {

	}
	property var configPages: []
	property var innerConfigDict: {
		"test": "test"
	}
	Component {
		id: stackLayoutItemComponent
		ColumnLayout {}
	}
	Component {
		id: stackLayoutItemLabelComponent
		Text {
			text: "Hello"
		}
	}
	Component {
		id: dropDownItemComponent
		DropDown {
			property string modelsKey
			onActivated: activatedIndex => {
							 OP.set(cfgForm, modelsKey, 'new')
						 }
		}
	}
	Component {
		id: checkBoxItemComponent
		CheckBox {}
	}
	Component {
		id: orderedTableItemComponent
		OrderedList {}
	}
	Component {
		id: paragraphItemComponent
		Text {
			text: "Paragraph"
		}
	}
	Component {
		id: sectionItemComponent
		Text {
			text: "section"
		}
	}
	Component {
		id: linkItemComponent
		Text {
			text: "link"
		}
	}
	Component {
		id: ipItemComponent
		TextField {
			text: "text item component"
		}
	}

	Component.onCompleted: {
		createStackLayoutFromJson(cfgForm, stackLayout)
	}
	function createStackLayoutFromJson(jsonObject, parent) {

		// Parses if object has following: 1 -
		innerConfigDict = {}
		const componentsMap = {
			"dropdown": dropDownItemComponent,
			"checkbox": checkBoxItemComponent,
			"orderedList": orderedTableItemComponent,
			"paragraph": paragraphItemComponent,
			"section": sectionItemComponent,
			"link": linkItemComponent,
			"ip": ipItemComponent,
			"dir": paragraphItemComponent
		}
		let stackLayoutId = 0
		// Create main stack layout
		function recursiveReader(recursiveObject, parentMenu, addressInObject) {
			// Iterates items object
			Object.keys(recursiveObject).forEach(objectKey => {
													 const el = recursiveObject[objectKey]
													 if (!el)
													 return
													 // If has own layout
													 if (el.meta.parent) {
														 recursiveReader(
															 el.schema,
															 el.meta.text,
															 objectKey)
													 }
													 if (el.schema) {
														 if (parentMenu) {
															 if (!innerConfigDict[parentMenu]) {
																 innerConfigDict[parentMenu] = []
															 }
															 innerConfigDict[parentMenu].push({
																								  "name": el.meta.text
																							  })
														 } else {
															 configPages.push({
																				  "name": el.meta && el.meta.text ? el.meta.text : objectKey,
																				  "icon": "../../resources/icons/quote_small.svg"
																			  })
														 }

														 const stackLayout = stackLayoutItemComponent.createObject(
															 parent)
														 if (!stackLayoutMap) {
															 stackLayoutMap = {}
														 }
														 stackLayoutMap[el.meta.text + '-'
																		+ (parentMenu
																		   || '')] = stackLayoutId
														 stackLayoutId += 1
														 const uiLabel = stackLayoutItemLabelComponent.createObject(
															 stackLayout, {
																 "text": el.meta.text
															 })
														 Object.keys(
															 el.schema).forEach(
															 key => {
																 const el2 = el.schema[key]
																 if (el2
																	 && el2.meta) {

																	 if (el2.meta.parent) {

																	 }
																	 if (el2.type) {
																		 const comp = componentsMap[el2.type]

																		 if (comp) {
																			 if (el2.type === 'dropdown') {
																				 el2.meta.modelsKey = addressInObject + '.' + key
																			 }
																			 const uiForm = comp.createObject(stackLayout, el2.meta)
																		 }
																		 // ToDo connect callbacks
																	 }
																 }
															 })
													 }
												 })
		}
		recursiveReader(jsonObject, undefined, '')
	}
	property var storageConfig: cfg
	property var newConfig: JSON.parse(JSON.stringify(cfg))
	signal editTrans(string transType)
	signal replyToTrans(string transType)
	GridLayout {
		anchors.fill: parent
		rows: 5
		columns: 7
		columnSpacing: 0
		rowSpacing: 0
		flow: GridLayout.LeftToRight
		Pane {
			Layout.columnSpan: 2
			Layout.rowSpan: 5
			Layout.fillHeight: true
			Layout.preferredWidth: 250
			padding: 0
			NestedList {
				id: tableSelector
				outerListSelectedIndex: 0
				outerList: configPages
				innerListDict: innerConfigDict
				onSelectListItem: (index, subIndex) => {
									  const parent = configPages[index].name
									  let key = parent + '-'
									  let child = ''
									  if (subIndex !== -1) {
										  child = innerConfigDict[parent][subIndex].name
										  key = child + '-' + parent
									  }
									  currentStackLayoutIndex = stackLayoutMap[key]
								  }
			}
		}
		Pane {
			Layout.columnSpan: 5
			Layout.rowSpan: 4
			Layout.fillWidth: true
			Layout.fillHeight: true
			padding: 10
			StackLayout {
				id: stackLayout
				anchors.fill: parent
				currentIndex: currentStackLayoutIndex
			}
		}
		Pane {
			Layout.columnSpan: 5
			Layout.rowSpan: 1
			Layout.fillWidth: true
			RowLayout {
				Button {
					text: "Save"
					onClicked: {
						backend.saveConfig(newConfig)
					}
				}
				Button {
					text: "Cancel"
				}
			}
		}
	}
}
