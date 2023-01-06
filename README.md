## Job description:

Dynamic creation of UI form in QML only based on JSON object. Creating table component with nested rows .

## Job minimal test case:
After job is complete following input would produce the output below it:

```json
{
  "appearanceAndBehhavior": {
    "text": "Appeareance & behaviour",
    "children": {
      "appearance": {
        "text": "Appearance",
        "items": {
          "themeDD": {
            "type": "dropdown",
            "label": "Theme",
            "options": [
              "Dracula",
              "Example"
            ]
          },
          "section": {
            "type": "section",
            "text": "Antialiasing"
          },
          "ideDD": {
            "type": "dropdown",
            "label": "Theme",
            "options": [
              "Dracula",
              "Example"
            ]
          },
          "editorDD": {
            "type": "dropdown",
            "label": "Theme",
            "options": [
              "Subpixel",
              "Example2"
            ]
          },
          "section2": {
            "type": "section",
            "text": "Accessibility"
          },
          "screenReaderCheckBox": {
            "type": "checkbox",
            "text": "Support screen readers",
            "desc": "Ctrl+Tab and Ctrl+Shift+tab will navigate UI controls in dialogs"
          }
        }
      }
    },
    "menus": {
      "text": "Menus and Toolbars",
      "type": "orderedTable",
      "rows": [
        {"text": "Maun Menu", "list":  ["file","edit","view","navigate","Code"]},{"text": "Menu toolbar", "list":  [1,2,3,4,5]},{"text": "Editor Popup Menu", "list":  [1,2,3,4,5]}
      ]
    }
  },
  "items": {
    "paragraph_1": {
      "type": "Paragraph",
      "text": "Customize IDE apperance and behaivor:...."
    },
    "a1": {
      "type": "link",
      "text": "Apperance",
      "href": "www.google.com"
    },
    "a2": {
      "type": "link",
      "text": "Menus and toolbars"
    },
    "a3": {
      "type": "link",
      "text": "System Settings"
    }
  },
  "keymap": {}
}
```

![Alt text](/andbehav.png?raw=true "Title")
![Alt text](/apperance.png?raw=true "Title")

## Components to parse:
These components need only to be parsed and created using qtquick control default components
(e.g., combobox, qt menu, checkbox). The menu need not to be implemented.
1. Menu item
2. Menu child item (Till level three)
3. Drop down with label you can use qml default drop down
4. Section (Example Antialiasing item)
5. Checkbox with label and paragraph

## Comoponents to be implemented
The table component inside menus and toolbars item is a special use case
it parses the item table and should have the following functionalities:
1. Two levels in each row, (Rows with nested items). Nested items don't have any other nested items
2. Reordering of nested items should be possibile either with up and down bottoms as in figure 3 or with drag and drop
3. APIs for Dynamic addition and deletion of nested objects from table should bew implemented 
![Alt text](/table.png?raw=true "Title")
![Alt text](/table2.png?raw=true "Title")
