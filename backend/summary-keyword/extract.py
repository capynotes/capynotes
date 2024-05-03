import re
import google.generativeai as genai
import os
from database import get_transcript_from_database, insert_keyword_definitions, insert_summary_to_database, get_user_id
# from aws_config import get_secret

def parse_keywords_and_definitions(text):
    print("text: ", text)
    keyword_dict = {}
    lines = text.replace('\n', '').split('**')
    for i in range(1, len(lines), 2):
        keyword = lines[i].strip().rstrip(':').lstrip(':')
        # Remove non-letter characters and "\n" from the end of the definition
        definition = re.sub(r'[^a-zA-Z\s]+$', '', lines[i + 1].strip())
        keyword_dict[keyword] = definition.strip().rstrip(':').lstrip(':')
    return keyword_dict

def summarize_keyword(note_id):

    # GEMINI_API_KEY= get_secret()

    # Configure genai with a valid API key
    genai.configure(api_key="")

    model = genai.GenerativeModel('gemini-pro')

    user_id = get_user_id(note_id) 
    print("userid: ", user_id)
    transcription = get_transcript_from_database(note_id)

    pre_prompt = f"In the following transcription please find required number of keywords based on the content so that the keywords are enough to cover the whole transcription. Give the keywords and the definition of the keywords that are understood and created from the given transcription. As a response give a list of keywords followed by their defintions in the format of <keyword>: <definition>. Here is the transcription:"

    prompt = pre_prompt + transcription

    response = model.generate_content(prompt)

    keywords_and_definitions = parse_keywords_and_definitions(response.text)

    #Insert the generated keywords and definitiosn to the database
    insert_keyword_definitions(keywords_and_definitions, note_id, user_id)

    
    #create summary
    pre_prompt = "Imagine you are a diligent student attending a lecture and taking comprehensive notes. Provide a detailed summary of the following transcription, organizing the content into meaningful headings and subheadings. The summary should accurately capture the main points discussed in the lecture, utilizing proper paragraph structure for readability. Here is the transcription: "
    prompt = pre_prompt + transcription
    summary_response = model.generate_content(prompt)

    #insert summary
    insert_summary_to_database(note_id, summary_response.text) 
