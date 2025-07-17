import json

import jsonpath_ng as jsonpath


def get_field_by_json_path(file_path, json_path_expression):
  try:
      with open(file_path, 'r') as file:
          print(f"Processing config file for API definition... {file_path}")
          data = json.load(file)
          name_query = jsonpath.parse(json_path_expression)
          return name_query.find(data)
  except FileNotFoundError:
      print(f"File {file_path} not found.")
  except json.JSONDecodeError:
      print(f"Error decoding JSON from file {file_path}.")
  except Exception as e:
      print(f"An error occurred while processing the file {file_path}: {e}")
