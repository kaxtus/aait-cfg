# QMLConf

## Overview
QML only implementation of UI forms generation of user configuration. The UI forms can be set using a schema file (e.g., QMLConf/config_schema.yaml) with `JSON` format.
The project uses PySide as an engine for QML only, but it doesn't depend on Python, and integrating it with your project is very simple. The part written in python is only in one file `Config.py`. This file has straight forward getters and setters for storing, reading, creating, and updating the user config. Therefore, it can be very easy to port to your language of sort such as c++.

## Requirements:
Python 3.8.10

### Install:
The example in this project uses `cerberus` package for validating the provided `CFG` file against the `CFG schema file`. 
```asm
pip3 install cerberus
```

### Run example:
```asm
python3 test.py
```
## How to:

