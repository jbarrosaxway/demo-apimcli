import json
import os

import docker
import utils

CONFIG_FILE = os.environ["CONFIG_FILES"]
CONFIG_FILES = json.loads(CONFIG_FILE)
APIM_IP = os.environ["APIM_INSTANCE_IP"]
APIM_USER = os.environ["APIM_INSTANCE_USER"]
APIM_PASSWORD = os.environ["APIM_INSTANCE_PASSWORD"]
UPDATE_CONFIG_FILES = []
IMPORT_CONFIG_FILES = []
docker_client = docker.from_env()


def export_env(key, value):
  # Define a variável de ambiente no GITHUB_ENV para uso em steps subsequentes
  with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as env_file:
      env_file.write(f"{key}={value}\n")


def export_env_and_output(key, value):
  print(f"Current value output export: {key}:{value}")
  export_env(key, value)
  # Escreve a saída no GITHUB_OUTPUT para uso no mesmo step
  with open(os.environ['GITHUB_OUTPUT'], 'a', encoding='utf-8') as output_file:
      output_file.write(f"{key}={value}\n")


for file in CONFIG_FILES:
  path = utils.get_field_by_json_path(file, "$.path")[0].value
  container_command = f"apim api get -h {APIM_IP} -u {APIM_USER} -port 8075 -p {APIM_PASSWORD} -a {path}"
  print(f"Running API search in apim-cli for file {file}")
  byte_result = docker_client.containers.run("bvieira123/apim-cli:1.14.4", container_command, stdout=True, stderr=True, remove=True)
  result = byte_result.decode('utf-8')
  if path in result:
    UPDATE_CONFIG_FILES.append(file)
  else:
    print(f"API config file is new {file}")
    IMPORT_CONFIG_FILES.append(file)

if UPDATE_CONFIG_FILES:
  export_env('UPDATE_CONFIG_FILES', json.dumps(UPDATE_CONFIG_FILES))
if IMPORT_CONFIG_FILES:
  export_env_and_output('IMPORT_CONFIG_FILES', json.dumps(IMPORT_CONFIG_FILES))
