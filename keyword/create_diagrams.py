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

    GOOGLE_API_KEY= "AIzaSyA9-15YBRgZv66CRhpkyflGWuAtM1QHZYY"

    # Configure genai with a valid API key
    genai.configure(api_key=GOOGLE_API_KEY)

    model = genai.GenerativeModel('gemini-pro')

    transcription = get_transcription() #change this method so that it retrieves the transcription from the database using note_id
    
    chat = model.start_chat(history=[])

    prompt = "In this chat, I will ask you to provide some mermaid diagramming language code. In your answers the format is significant because I directly copy your answer to use. Do not forget to write 'graph TB' or 'graph TB' at the top of every diagram. Using 'subgraph' in your code is prohibited. Always use arrows to show relation between nodes. In your mermaid code use letters for node ids. Use Square brackets to give a name to a node. For instance, A[An Example Node]. Moreover, in your answer, do not write any additional letter, word or sentence to communicate with me because I will not read your message, I directly use them. In the following message I will prove an example mermaid code. You need to provide using similar grammars. Later, I will provide a transcript which you will generate diagrams about."
    response = chat.send_message(prompt)

    prompt = """Here is an example mermaid code, this is only for to demonstrate the grammar, content of the following diagram is not related to the transcription content: 
    graph TB
    A[Colors] --> B[Red]
    A --> C[Green]
    A --> D[Sky Blue]"""    

    response = chat.send_message(prompt)

    pre_prompt = f"Based on the following transcription, it is aimed to generate diagrams showing the relations beetween titles. For example, arrows from a title should go to the subtitles covered under this title. For instance, under the title 'history', 'primitive age', 'stone age' and 'modern age' can be covered. A node without any arrows pointing to or from it cannot be included in the diagram. You need to generate a number of diagrams. You need to decide the number of diagrams based on the transcription's context. The diagrams are should be in Mermaid Diagramming Language. Your output will be a bullet pointed list(i.e. use asteriks for each point). Bullet points will be diagrams in Mermaid Diagramming Language. Each bullet point will be for one diagram. Here is the transcription: "
    prompt = pre_prompt + transcription

    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------1")


    pre_promt = "You need to use arrows to indicate the relation between topics. If you don not use add them. If you already use ignore this prompt. In either condition, just provide the mermaid code for diagrams, nothing else"
    prompt = pre_promt
    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------2")

    pre_promt = "Please be sure that every seperated diagram is written under different bullet points. Not with hyphen, just use bullet points for each mermaid code. The bullet points should be represented with asteriks(*). If there are words 'mermaid' in the output, remove them"
    prompt = pre_promt
    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------3")


    pre_promt = "If you use whitespaced node names use square brackets as in the following example 'A[An Example Node]'. If you do in this way already ignore this prompt. In either condition, just provide the mermaid code for diagrams, nothing else"
    prompt = pre_promt
    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------4")

    pre_promt = "Do not use intertwined subgraph notations. The most importantly, give a working mermaid code. Check if the code follows the grammer of the language. Give the final version of your output following the previous constraints in this chat."
    prompt = pre_promt
    response = chat.send_message(prompt)
    print(response.text)
    print("----------------------------------5")

if __name__ == "__main__":
    main()  