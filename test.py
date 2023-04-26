import resources_rc # This is necessary
import sys
from PySide2.QtGui import QGuiApplication
from PySide2.QtQml import QQmlApplicationEngine
from Config import Config


app = QGuiApplication(sys.argv)
engine = QQmlApplicationEngine()
engine.quit.connect(app.quit)

config = Config(set_context_property=engine.rootContext().setContextProperty)
engine.rootContext().setContextProperty("qmlconf", config)
engine.load('./qml/main.qml')
sys.exit(app.exec_())