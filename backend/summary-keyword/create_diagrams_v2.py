import google.generativeai as genai
import os
import time

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

    transcription = get_transcription()
    
    chat = model.start_chat(history=[])

    prompt = "Imagine your only job is to provide accurate Marmaid Programming Language Code based on the given context. When you are asked your only job is to provide a marmaid diagram at a time. Do not provide any additional message  or response to me except the one Marmaid Diagram Code."
    response = chat.send_message(prompt)
    print(response.text)

    diagram_generated = True
    prompt =  " Please provide a mermaid code for a diagram based on the following transcription. The diagrams should show the relations beetween some titles. For example, arrows from a title should go to the subtitles covered under this title. For instance, under the title 'history'; 'primitive age', 'stone age' and 'modern age' can be covered. A node without any arrows pointing to or from it cannot be included in the diagram. You need to decide the diagram based on the transcription's context. Only give one graph(i.e. one subgraph structure). If you have more than one diagram idea, keep it to print later. Nodes in the graph should be connected to at least one of the other nodes with arrows. Do not forget to add 'graph LR' or 'graph TB' at the top of the code. All the information given in the diagrams must based on the transcription. No additional information that are not in the transcription can be added into diagrams. Here is the transcription: "
    prompt = prompt + transcription
    response = chat.send_message(prompt)
    diagram = response.text
    print(diagram)

    while (diagram_generated):
        prompt =  " If there is any other diagram that can be provided based on the given transcription before, please provide. The diagram should be different than the ones that you provided before. The diagrams should show the relations beetween some titles. For example, arrows from a title should go to the subtitles covered under this title. For instance, under the title 'history'; 'primitive age', 'stone age' and 'modern age' can be covered. A node without any arrows pointing to or from it cannot be included in the diagram. You need to decide the diagram based on the transcription's context. Only give one graph(i.e. one subgraph structure). If you have more than one diagram idea, keep it to print later. Nodes in the graph should be connected to at least one of the other nodes with arrows. If there is not any diagrams left to generate for this request, only say 'Finished' so that we can end the program. Do not forget to add 'graph LR' or 'graph TB' at the top of the code. All the information given in the diagrams must based on the transcription. No additional information that are not in the transcription can be added into diagrams."
        prompt = prompt + transcription
        time.sleep(1)
        response = chat.send_message(prompt)
        diagram = response.text
        print(diagram)

        if (diagram == 'Finished'):
            diagram_generated = False
if __name__ == "__main__":
    main()  