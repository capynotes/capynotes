import google.generativeai as genai
import os
def get_transcription():

    current_directory = os.path.dirname(os.path.realpath(__file__))
    file_path = os.path.join(current_directory, 'test.txt')
    transcription = ""
    with open(file_path, 'r') as file: 
        transcription = file.read()
    return transcription

def main():

    GOOGLE_API_KEY= ""

    # Configure genai with a valid API key
    genai.configure(api_key=GOOGLE_API_KEY)

    model = genai.GenerativeModel('gemini-pro')

    transcription = get_transcription() #change this method so that it retrieves the transcription from the database using note_id
    
    chat = model.start_chat(history=[])

    pre_prompt = f"Based on the following transcription, it is aimed to generate diagrams showing the relations beetween titles. For example, arrows from a title should go to the subtitles covered under this title. For instance, under the title 'history', 'primitive age', 'stone age' and 'modern age' can be covered. These diagrams will be in Mermaid Programming Language. A node without any arrows pointing to or from it cannot be included in the diagram. You need to generate a number of diagrams. You need to decide the number of diagrams based on the transcription's context. The diagrams are should be in Mermaid Diagramming Language. Your output will be a bullet pointed list(i.e. use asteriks for each point). Bullet points will be diagrams in Mermaid Diagramming Language. Each bullet point will be for one diagram. Here is the transcription: "
    prompt = pre_prompt + transcription

    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------1")


if __name__ == "__main__":
    main()  