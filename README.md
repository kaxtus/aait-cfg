# Parse UI form from JSON to QML 
This program parses yaml configuration file accompanied by a form yaml file and generate UI qml form based on the yaml config file.
## Start project
### Pre-requirements:
- PySide2 for qml
- Cerberus for configuration validation
- PyYaml for reading yaml files

These libs can be installed using command:
```asm
pip3 install pyside2 cerberus pyyaml
```
Run with
```asm
python3 test.py
```
## UI Components:
These components need only to be parsed and created using qtquick control default components
(e.g., combobox, qt menu, checkbox). The menu need not to be implemented.
1. Menu item
2. Menu child item (Till level three)
3. Dropdown with label you can use qml default drop down
4. Section (Example Antialiasing item)
5. Checkbox with label and paragraph
6. Ordered List

