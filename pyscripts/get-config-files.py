import json
import os

import utils

file_list = os.environ["CHANGES"].split(',')
conf_files_list = []


def add_in_conf_files_list(file):
  print(f"Checking if the {file} are not in the config files list...")
  if file not in file_list:
      conf_files_list.append(file)


def export_env(key, value):
  # Define a variável de ambiente no GITHUB_ENV para uso em steps subsequentes
  with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as env_file:
      env_file.write(f"{key}={value}\n")


def process_api_defition(file_path):
  directory, file_name = os.path.split(file_path)
  for root, _, files in os.walk(directory):
      for file in files:
          print(f"Getting correctly config file for api defition file {file_name}")
          if file.endswith('-config.json'):
              file_path = os.path.join(root, file)
              config_file_path = utils.get_field_by_json_path(file_path, "$.apiSpecification.resource")[0].value
              if config_file_path != "":
                  return config_file_path


for file in file_list:
  if "-config" in file.lower():
    print(f"Processing config file: {file}")
    conf_files_list.append(file)
  else:
    print(f"Processing API Definition file")
    add_in_conf_files_list(process_api_defition(file))

export_env('CONFIG_FILES', json.dumps(conf_files_list))