from flask import Blueprint, request, jsonify
from app.summarize import summarize_text

main_bp = Blueprint('main', __name__)

@main_bp.route('/summarize', methods=['POST'])
def summarize_route():
    requestBody = request.get_json()
    textPath = requestBody.get('transcription')
    summary = summarize_text(textPath)
    return jsonify({'summary': summary})
