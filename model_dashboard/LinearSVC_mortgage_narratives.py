#!/usr/bin/env python3
# -*- coding: utf-8 -*-

def LinearSVC_mortgage_narratives(new_narrative):
    ## LinearSVC Pipeline
    from sklearn.svm import LinearSVC
    from sklearn.pipeline import Pipeline
    from sklearn.feature_extraction import text
    from sklearn.feature_extraction.text import TfidfVectorizer
    from sklearn.model_selection import train_test_split
    import pandas as pd
    
    df = pd.read_csv('data/narratives_mortgage.csv')
    minv = df.groupby('Company response to consumer')['Company response to consumer'].value_counts().min()
    df = df.groupby('Company response to consumer', group_keys=False).apply(lambda x: x.head(minv))
    df.columns = ['Company_response_to_consumer', 'Consumer_complaint_narrative']
    
    my_stop_words = text.ENGLISH_STOP_WORDS.union(["xxxx", "XXXX", "xx", "XX", "xxxxxxxx", "XXXXXXXX"])
    
    X_train_text, X_test_text, y_train_text, y_test_text = train_test_split(
        df.Consumer_complaint_narrative, df.Company_response_to_consumer, random_state = 0)
    
    model_svc = Pipeline([('tfidf_vectorizer', TfidfVectorizer(sublinear_tf=True, norm='l2', encoding='latin-1', 
                            ngram_range=(1, 2),
                            min_df = 0.001,
                            stop_words= my_stop_words,
                           token_pattern = '(?u)\\b\\w*[a-zA-Z]\\w*\\b')),
                         ('linear_svc', LinearSVC())])
    
    model_svc_fit = model_svc.fit(X_train_text, y_train_text)
    ## print(model_svc_fit.score(X_test_text, y_test_text))
    return print(model_svc_fit.predict([new_narrative]))
