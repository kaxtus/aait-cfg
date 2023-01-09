from cerberus import Validator, TypeDefinition
import yaml
import json

CONFIG_DIR = 'test_config.yaml'
CONFIG_SCHEMA_DIR = 'test_config_schema.yaml'

def read_yaml(yaml_dir):
    with open(yaml_dir, 'r') as stream:
        try:
            return yaml.safe_load(stream)
        except yaml.YAMLError as exc:
            print(exc)

def get_template_config(file_dir):
    return read_yaml(file_dir + '/config.yaml')

def get_cfg_form():
    form_cfg = open(CONFIG_SCHEMA_DIR, 'r').read()
    form_cfg = form_cfg.replace('\'', '"').replace('True', 'true')
    return json.loads(form_cfg)


cfg = read_yaml(CONFIG_DIR)

# Define types for config
dir_type = TypeDefinition('dir', (str,), ())
Validator.types_mapping['dir'] = dir_type

ip_type = TypeDefinition('ip', (str,), ())
Validator.types_mapping['ip'] = ip_type

checkbox_type = TypeDefinition('checkbox', (bool,), ())
Validator.types_mapping['checkbox'] = checkbox_type

ordered_list_type = TypeDefinition('orderedList', (list,), ())
Validator.types_mapping['orderedList'] = ordered_list_type

schema = eval(open(CONFIG_SCHEMA_DIR, 'r').read())
v = Validator(schema)

print("CONFIG VALIDATION")
print(v.validate(cfg, schema))
print(v.errors)


