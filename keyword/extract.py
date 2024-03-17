import textwrap
import re
import google.generativeai as genai
import os
from database import get_transcript_from_database, insert_keyword_definitions, insert_summary_to_database
from IPython.display import display
from IPython.display import Markdown




def parse_keywords_and_definitions(text):
    keyword_dict = {}
    lines = text.replace('\n', '').split('**')
    for i in range(1, len(lines), 2):
        keyword = lines[i].strip().rstrip(':')
        # Remove non-letter characters and "\n" from the end of the definition
        definition = re.sub(r'[^a-zA-Z\s]+$', '', lines[i + 1].strip())
        keyword_dict[keyword] = definition
    return keyword_dict

def get_transcription():

    current_directory = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(current_directory, 'test.txt')
    transcription = ""
    with open(file_path, 'r') as file: 
        transcription = file.read()
    return transcription

def main():

    GOOGLE_API_KEY= "AIzaSyA9-15YBRgZv66CRhpkyflGWuAtM1QHZYY"

    # Configure genai with a valid API key
    genai.configure(api_key=GOOGLE_API_KEY)

    model = genai.GenerativeModel('gemini-pro')
    transcription = get_transcription() #change this method so that it retrieves the transcription from the database using note_id
    
    x = 1
    pre_prompt = f"In the following transcription please find {x} or more number of keywords based on the content. Give the keywords and the definition of the keywords that are understood and created from the given transcription. As a response give a list of keywords followed by their defintions in the format of <keyword>: <definition>. Here is the transcription:"

    prompt = pre_prompt + transcription
    response = model.generate_content(prompt)
    keywords_and_definitions = parse_keywords_and_definitions(response.text)
    #insert keyword and definitions
    insert_keyword_definitions(keywords_and_definitions)
    print("----------------------------------------")
    
    #create summary
    pre_prompt = "Provide an extensive summary of the following transcription as if a student attending this lecture is taken notes from this transcript. Provide meaningful headings and subheadings. Under the subheadings include summarized paragraphs. Do not use any other source other than this text: "
    prompt = pre_prompt + transcription
    summary_response = model.generate_content(prompt)
    print(summary_response.text)
    #insert summary
    insert_summary_to_database(summary_response.text)





if __name__ == "__main__":
    main()