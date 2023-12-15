from flask import Flask, request, jsonify
import subprocess


app = Flask(__name__)

@app.route("/")
def summarize():
    summarizerPath = "summarization1.py"
    longTextPath = "testFile.txt"
    result = subprocess.run(['python', summarizerPath, longTextPath], capture_output = True, text = True)
    summary = result.stdout.strip()
    return summary

@app.route("/summarize", methods=['POST'])
def summarizeFromText():

    requestBody = request.get_json()

    textPath = requestBody.get('textPath')
    summarizerPath = "summarization1.py"
    result = subprocess.run(['python', summarizerPath, textPath], capture_output = True, text = True)
    summary = result.stdout.strip()
    return jsonify({'summarization': summary})


if __name__ == "__main__":
    app.run()