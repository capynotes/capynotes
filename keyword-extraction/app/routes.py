from flask import Blueprint, request, jsonify
from app.keywordExtraction import extract_keywords

main_bp = Blueprint('main', __name__)

@main_bp.route('/keywords', methods = ['POST'])
def keyword_extraction_route():
    requestBody = request.get_json()
    text= requestBody.get('text')
    keywords = extract_keywords(text)
    return jsonify({'keywords': keywords})
