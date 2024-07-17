import os
import subprocess

from flask import Flask, send_file

port = 8080
app = Flask(__name__)

print("Trying to run a socket server on:", port)

@app.route("/")
def hello_world():
    return 'This is main page.'


@app.route("/molecule")
def run_python():
    try:#Run 'molecule.py'
        result = subprocess.run(['python', 'molecule.py'], capture_output=True, text=True)
        if result.returncode != 0:
            return 'An error occurred while running the file.'
    except Exception as e:
        return str(e)
    
    try:#Download 'molecule.glb'
        file_name = "molecule.glb"
        os.system('molecule.py')
        if os.path.exists(file_name):
            return send_file(file_name, as_attachment=True)
        else:
            return 'File not found!'
    except Exception as e:
        return str(e)

app.run(port=port)
