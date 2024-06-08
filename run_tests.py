import os
import subprocess
from datetime import datetime

def create_result_directory():
    # Cria a pasta 'result' se ela não existir
    if not os.path.exists('result'):
        os.makedirs('result')

    # Cria uma subpasta com base na data e hora atual
    subdir_name = datetime.now().strftime('result_%Y%m%d_%H%M%S')
    result_dir = os.path.join('result', subdir_name)
    os.makedirs(result_dir)
    return result_dir

def run_robot_tests(result_dir):
    # Comando para rodar os testes do Robot Framework
    command = [
        'robot',
        '--outputdir', result_dir,
        'tests'  # Substitua pelo caminho para sua suite de testes
    ]
    subprocess.run(command)

if __name__ == "__main__":
    result_directory = create_result_directory()
    run_robot_tests(result_directory)
