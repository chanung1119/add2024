import os
import subprocess

from flask import Flask, send_file, render_template_string
from flask_cors import CORS

port = 8080
app = Flask(__name__)
CORS(app)

print("Trying to run a socket server on:", port)

@app.route("/")
def hello_world():
    return 'This is main page.'


@app.route("/molecule.glb")
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

@app.route("/modelViewer")
def index():
    return render_template_string('''
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <script type="module" src="https://unpkg.com/@google/model-viewer/dist/model-viewer.min.js"></script>
    </head>
    <body>
        <model-viewer src="http://127.0.0.1:8080/molecule.glb" alt="A 3D model" auto-rotate camera-controls></model-viewer>
    </body>
    </html>
    ''')


app.run(port=port)
