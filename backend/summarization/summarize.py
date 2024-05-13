# Abstracts the full text, summarize from third person pov
import sys
from transformers import pipeline

def summarize_text(transcript):
    summarizer = pipeline("summarization", "pszemraj/long-t5-tglobal-base-16384-book-summary")
    max = 450 
    min = 150
    summary = summarizer(transcript, max_length = max, min_length = min)
    return summary[0]["summary_text"]


# summarizer = pipeline("summarization", "pszemraj/long-t5-tglobal-base-16384-book-summary")

# long_text = """I remember as a child, and as a young budding naturalist, spending all my time observing and testing the world around me
# moving pieces, altering the flow of things, and documenting ways the world responded to me. Now, as an adult and a professional 
# naturalist, I’ve approached language in the same way, not from an academic point of view but as a curious child still 
# building little mud dams in creeks and chasing after frogs. So this book is an odd thing: it is a naturalist’s walk through the language 
# making landscape of the English language, and following in the naturalist’s tradition it combines observation, experimentation, 
# speculation, and documentation—activities we don’t normally associate with language."""
# max = 150 
# min = 60

# if len(sys.argv) > 1:
#     long_text_path = sys.argv[1]
#     f = open(long_text_path)
#     long_text = f.read()
#     if len(sys.argv) > 2:
#         max = int(sys.argv[2])
#         if len(sys.argv) > 3:
#             min = int(sys.argv[3])
           
# long_text2 = """In recent years, advancements in artificial intelligence (AI) have revolutionized various industries, from healthcare to finance. The integration of machine learning algorithms and deep neural networks has enabled computers to analyze vast amounts of data, identify patterns, and make predictions with unprecedented accuracy. One notable application is in the field of autonomous vehicles, where AI plays a crucial role in enhancing safety and navigation. However, the rapid evolution of AI also raises ethical concerns, such as bias in algorithms and the potential for job displacement. Despite these challenges, the transformative impact of AI on society is undeniable, prompting ongoing discussions about responsible development and deployment"""
# long_text3 = """The global shift towards renewable energy sources has gained momentum as countries seek sustainable alternatives to traditional fossil fuels. Solar power, in particular, has emerged as a key player in the clean energy landscape. Photovoltaic technology harnesses sunlight to generate electricity, offering a renewable and environmentally friendly solution. Governments and businesses worldwide are investing in solar infrastructure to reduce carbon emissions and mitigate the impact of climate change. Despite initial challenges, such as high upfront costs, advancements in solar technology and decreasing prices of solar panels have made it increasingly accessible. The transition to solar energy reflects a broader commitment to a greener future and a reduced reliance on finite resources."""
# result = summarizer(long_text, max_length = max, min_length = min)
# print(result[0]["summary_text"])