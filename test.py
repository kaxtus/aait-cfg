import sys
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from config import get_cfg_form, cfg
import resources_rc

app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)
engine.rootContext().setContextProperty("cfgForm", get_cfg_form())
engine.rootContext().setContextProperty("cfg", cfg)
engine.load('./qml/main.qml')
sys.exit(app.exec_())