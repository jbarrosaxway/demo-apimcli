import json, os
import jsonpath_ng as jsonpath

file_list = os.environ["CHANGES"].split(',')
conf_files_list = []

def add_in_conf_files_list(file):
    print(f"Checking if the {file} are not in the config files list")
    if file not in file_list:
        conf_files_list.append(config_file)

def export_env(key, value):
  # Define a variável de ambiente no GITHUB_ENV para uso em steps subsequentes
  with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as env_file:
      env_file.write(f"{key}={value}\n")

def get_config_file_of_api_definition_file(file_path, file_name):
    try:
        with open(file_path, 'r') as file:
            print("Processing config file to api definition...")
            data = json.load(file)
            name_query = jsonpath.parse("$.apiSpecification.resource")
            value = name_query.find(data)
            if file_name in value[0].value:
                return file_path
            return ""
            
    except FileNotFoundError:
        print(f"File {file_path} not found.")
    except json.JSONDecodeError:
        print(f"Error decoding JSON from file {file_path}.")
    except Exception as e:
        print(f"An error occurred while processing the file {file_path}: {e}")

def process_api_defition(file_path):
    directory, file_name = os.path.split(file_path)
    for root, _, files in os.walk(directory):
        for file in files:
            print(f"Getting correctly config file for api defition file {file_name}")
            if file.endswith('-config.json'):
                file_path = os.path.join(root, file)
                config_file_path = get_config_file_of_api_definition_file(file_path, file_name)
                if config_file_path != "":
                    return config_file_path

for file in file_list:
    config_file = ""
    if "-config" in file.lower():
      print(f"Processing config file: {file}")
      conf_files_list.append(file)
    else:
        print(f"Processing API Definition file")    
        config_file = process_api_defition(file)
        add_in_conf_files_list(config_file)

export_env('CONFIG_FILES', json.dumps(conf_files_list))