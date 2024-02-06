from keybert import KeyBERT

def extract_keywords(text):
    kwModel = KeyBERT()
    keywordsAndScores = kw_model.extract_keywords(text, keyphrase_ngram_range=(1,1))

    keywords = []

    # Remove scores, just return keywords in a list
    for keyword, _ in keywordsAndScores:
        keywords.append(keyword)
    return keywords
