import os, json, docker
import jsonpath_ng as jsonpath

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
    export_env(key, value)
    # Escreve a saída no GITHUB_OUTPUT para uso no mesmo step
    with open(os.environ['GITHUB_OUTPUT'], 'a', encoding='utf-8') as output_file:
        output_file.write(f"{key}={value}\n")

def get_api_path(file_path):
    print(f"{file_path}")
    try:
        with open(file_path, 'r') as file:
            print("Processing config file to get path...")
            file_data = json.load(file)
            name_query = jsonpath.parse("$.path")
            json_field = name_query.find(file_data)
            return json_field[0].value
    except FileNotFoundError:
        print(f"File {file_path} not found.")
    except json.JSONDecodeError:
        print(f"Error decoding JSON from file {file_path}.")
    except Exception as e:
        print(f"An error occurred while processing the file {file_path}: {e}")

for file in CONFIG_FILES:
    path = get_api_path(file)
    container_command = f"apim api get -h {APIM_IP} -u {APIM_USER} -port 8075 -p {APIM_PASSWORD} -a {path}"
    print("Running api search in apim-cli...")
    byte_result = docker_client.containers.run("bvieira123/apim-cli:1.14.4", container_command, stdout=True, stderr=True, remove=True)
    result = byte_result.decode('utf-8')
    if path in result:
        UPDATE_CONFIG_FILES.append(file)
    else:
        IMPORT_CONFIG_FILES.append(file)

export_env('UPDATE_CONFIG_FILES', UPDATE_CONFIG_FILES)
export_env_and_output('MATRIX', json.dumps(IMPORT_CONFIG_FILES))