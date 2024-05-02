import re
import google.generativeai as genai
import os
from database import get_transcript_from_database, insert_keyword_definitions, insert_summary_to_database, get_user_id
# from aws_config import get_secret

def parse_keywords_and_definitions(text):
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

    pre_prompt = f"Based on the following transcription, your aim is to generate diagrams showing the relations between topics, concepts, or titles. You need to generate a number of diagrams. You need to decide the number of diagrams based on the transcription's context. Some diagrams can be grouped together under 1 diagram in a meaningful way. The diagrams should be in Mermaid Diagramming Language. Do not forget to use “graph TB” in your diagrams. Do not use quotation marks in your diagrams outside of parentheses. Your diagrams should be comprehensive and logical. If the topic can be understood without a diagram(i.e. Too small, 1 line diagram), do not provide that diagram. If your diagram is too long to fit on a page, split it into parts. The provided diagrams’ context should not be similar to each other. Your output will be a bullet-pointed list(i.e., use asterisks for each diagram). Each bullet point will be for one diagram. Do not use any other symbol to separate the diagrams from each other. Make sure the diagramming language code you provided is correct and working. Here is the transcription:"

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
