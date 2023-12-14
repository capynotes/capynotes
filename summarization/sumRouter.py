from flask import Flask
import subprocess


app = Flask(__name__)

@app.route("/")
def summarize():
    summarizerPath = "summarization1.py"
    longTextPath = "testFile.txt"
    result = subprocess.run(['python', summarizerPath, longTextPath], capture_output = True, text = True)
    summary = result.stdout.strip()
    return summary

if __name__ == "__main__":
    app.run()