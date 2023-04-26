import yaml
import json
import logging
from cerberus import Validator, TypeDefinition
from PySide2.QtCore import QObject, Slot, Property, Signal
CONFIG_DIR = './config.yaml'
CONFIG_SCHEMA_DIR = './config_schema.yaml'
log = logging.getLogger('QMLConf')


def read_yaml(yaml_dir):
    """
    Read yaml to directory
    :param yaml_dir: storage directory
    :return: dict({}) representing configuration
    """
    with open(yaml_dir, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            raise exc


def write_yaml(yaml_dir, new_cfg):
    """
    Writes dict to directory
    :param yaml_dir: storage directory string
    :param new_cfg: json new config
    :return:
    """
    with open(yaml_dir, 'w') as outfile:
        yaml.dump(new_cfg, outfile, default_flow_style=False)


class Config(QObject):
    changed_signal = Signal()

    def __init__(self, dir=CONFIG_DIR, schema_dir=CONFIG_SCHEMA_DIR, set_context_property=None):
        """
        Initiate Object
        :param dir: directory of yaml config
        :param schema_dir: directory of json schema defining the UI form components
        :param set_context_property: qml engine setContextProperty function
        """
        super().__init__()
        assert set_context_property is not None, '(Set Context Property) Parameter Error: simply use value engine.rootContext().setContextProperty'
        self._dir = dir
        self._schema_dir = schema_dir
        self._cfg = read_yaml(dir)
        self.schema_cfg = read_yaml(schema_dir)
        self.validate_schema()
        self._form = json.loads(open(self._schema_dir, 'r').read().replace('\'', '"').replace('True', 'true'))

    @Property('QVariant', notify=changed_signal)
    def cfg(self):
        """
        Returns the values in config file as json
        :return: user config stored in self._dir as json
        """
        return self._cfg

    @cfg.setter
    def cfg(self, a):
        pass

    @Property('QVariant', notify=changed_signal)
    def form(self):
        return self._form

    @form.setter
    def form(self, a):
        self._form = a
        self.changed_signal.emit()

    def validate_schema(self):
        """
        Validate user config stored in self._dir
        against user config schema stored in self._schema_cfg
        :return:
        """
        # Layer NA: First layer of defining new components and forms
        id_type = TypeDefinition('id', (str,), ())
        Validator.types_mapping['id'] = id_type

        dir_type = TypeDefinition('dir', (str,), ())
        Validator.types_mapping['dir'] = dir_type

        ip_type = TypeDefinition('ip', (str,), ())
        Validator.types_mapping['ip'] = ip_type

        checkbox_type = TypeDefinition('checkbox', (bool,), ())
        Validator.types_mapping['checkbox'] = checkbox_type

        ordered_list_type = TypeDefinition('orderedList', (list,), ())
        Validator.types_mapping['orderedList'] = ordered_list_type
        # Layer NA finish

        schema = eval(open(self._schema_dir, 'r').read())\

        # Raises exceptions
        Validator(schema)

    @Slot('QVariant', result=str)
    def write(self, new_cfg_var):
        """
        Writes user cfg to file set in self._dir
        :paeram new_cfg_var:
        :return:
        """
        new_cfg = new_cfg_var.toVariant()
        try:
            write_yaml(CONFIG_DIR, new_cfg)
            self.cfg = new_cfg
        except Exception as e:
            log.exception(e)
            # Revert changes to config
            write_yaml(CONFIG_DIR, self.cfg)
            return str(e)
        self.changed_signal.emit()
        return ''
