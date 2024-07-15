from flask import Flask, jsonify, send_file
import subprocess
import os

app = Flask(__name__)
port = 55001

@app.route('/', methods=['GET'])
def run_script():
    try:
        result = subprocess.run(['python', 'script.py'], capture_output=True, text=True)
        if result.returncode == 0:
            return jsonify({"message": "Script executed successfully!", "output": result.stdout})
        else:
            return jsonify({"message": "Script execution failed!", "error": result.stderr}), 500
    except Exception as e:
        return jsonify({"message": "An error occurred while running the script!", "error": str(e)}), 500
    
@app.route('/download-file', methods=['GET'])
def download_file():
    file_name = "molecule.glb"
    try:
        if os.path.exists(file_name):
            return send_file(file_name, as_attachment=True)
        else:
            return jsonify({"message": "File not found!"}), 404
    except Exception as e:
        return jsonify({"message": "An error occurred while downloading the file!", "error": str(e)}), 500

if __name__ == '__main__':
    app.run(port=port)
