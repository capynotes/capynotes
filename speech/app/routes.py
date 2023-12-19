from flask import Blueprint, request, jsonify
from app.transcribe import aws_transcribe_audio
from app.transcribe import whisper_transcribe_audio
from app.video_to_mp4 import video_to_mp4

main_bp = Blueprint('main', __name__)

@main_bp.route('/transcribe', methods=['POST'])
def transcribe_route():
    # Receive information about the uploaded audio file from Java Spring
    data = request.get_json()

    # Extract necessary information (e.g., S3 file key) from the data
    file_name = data.get('file_name')

    # Transcribe the audio file
    transcription = whisper_transcribe_audio(file_name)

    # Return the transcription in the response
    return jsonify({'transcription': transcription})

@main_bp.route('/youtube', methods=['POST'])
def youtube_route():
    # Receive information about the video from Java Spring
    data = request.get_json()

    # Extract necessary information (e.g., url) from the data
    video_url = data.get('videoUrl')
    note_name = data.get('noteName')

    # convert to mp4
    object_name = video_to_mp4(video_url, note_name)
    if object_name:
        transcription = whisper_transcribe_audio(object_name)
    else:
        transcription = "An Error Occurred. Please Try Again Later."
    # Return the transcription in the response
    return jsonify({'transcription': transcription})