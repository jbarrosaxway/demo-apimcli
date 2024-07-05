[Yesterday 6:07 PM] Joao Jacinto de Barros (External)
export_env_and_output('MATRIX', json.dumps(filtered_environment_names))
 
[Yesterday 6:07 PM] Joao Jacinto de Barros (External)
def export_env_and_output(key, value):
    # Define a variável de ambiente no GITHUB_ENV para uso em steps subsequentes
    with open(os.environ['GITHUB_ENV'], 'a', encoding='utf-8') as env_file:
        env_file.write(f"{key}={value}\n")
   
    # Escreve a saída no GITHUB_OUTPUT para uso no mesmo step
    with open(os.environ['GITHUB_OUTPUT'], 'a', encoding='utf-8') as output_file:
        output_file.write(f"{key}={value}\n")
 
[Yesterday 6:09 PM] Joao Jacinto de Barros (External)
    strategy:
      matrix:
        environment: ${{fromJson(needs.pre-processamento.outputs.matrix)}}
    environment: ${{ matrix.environment }}
 