from hf_token import get_hf_token
from langchain_community.llms import HuggingFaceEndpoint, CTransformers
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

def extract_keywords(summary_text):
    hft = get_hf_token()

    template = """Question: {question}"""
    prompt = PromptTemplate(template=template, input_variables=["question"])
    llm = HuggingFaceEndpoint(repo_id = "HuggingFaceH4/zephyr-7b-alpha", temperature = 0.1, huggingfacehub_api_token=hft)
    chain = LLMChain(prompt=prompt, llm=llm, verbose=True)

    prompt = " Extract ONLY the GENUINELY important, significant, technical and definiton-worthy keywords using ONLY AND ONLY THIS TEXT (do NOT overextract) and give their DEFINITIONS (NO bullet points) in the format: '1. keyword_1 - definition_1 \n 2. keyword_2 - definition_2 \n ...'"

    result = chain.invoke(summary_text + prompt)
    print("first RESULT: ", result)

    primary_answer = result.get("text", "").split("\n\nQuestion:")[0].strip() if result else None

    print("primary answer: ", primary_answer)
    print()

    lines = primary_answer.split('\n')
    lines = [line.strip() for line in lines if line.strip() and not line.startswith("Answer:") and not line.startswith("Answer")]
    print(lines)
    keyword_list = [{'keyword': (line.split(' - ')[0].strip()).split('.')[1].strip(), 'definition': line.split(' - ')[1].strip()} for line in lines]

    print("keyword list: ", keyword_list)
    print()

    #return keyword_list

extract_keywords("'In this chapter, we continue our discussion of threads and how they can be used to create more than one application. Because the system supports only one thread for every application, each application can use multiple threads that are created by the thread library that is being ported into the other applications. The difficulty with this is that the central execution system does not know about the threading and therefore cannot execute the same code over and over again.'")