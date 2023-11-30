from flask import Blueprint, request, jsonify
from app.transcribe import transcribe_audio

main_bp = Blueprint('main', __name__)

@main_bp.route('/transcribe', methods=['POST'])
def transcribe_route():
    # Receive information about the uploaded audio file from Java Spring
    data = request.get_json()

    # Extract necessary information (e.g., S3 file key) from the data
    file_name = data.get('file_name')

    # Transcribe the audio file
    transcription = transcribe_audio(file_name)

    # Return the transcription in the response
    return jsonify({'transcription': transcription})