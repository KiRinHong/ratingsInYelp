import pandas as pd
import numpy as np
from nltk.classify.util import accuracy
from nltk import pos_tag
from nltk.corpus import wordnet
from nltk.classify import NaiveBayesClassifier
from nltk.classify import MaxentClassifier

review_brunch = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_brunch.csv', lineterminator='\n', index_col=0)
review_brunch = review_brunch.drop(['business_id', 'date'], axis=1).dropna().reset_index(drop=True)
review_brunch[review_brunch.isnull().any(axis=1)]
review_brunch['target'] = np.where(review_brunch['stars'] > 3.0, 'positive', 'negative')


def get_wordnet_pos(pos_tag):
    if pos_tag.startswith('J'):
        return wordnet.ADJ
    elif pos_tag.startswith('V'):
        return wordnet.VERB
    elif pos_tag.startswith('N'):
        return wordnet.NOUN
    elif pos_tag.startswith('R'):
        return wordnet.ADV
    else:
        return wordnet.NOUN


def get_noun(text):
    pos_tags = pos_tag(text.split())
    return ' '.join([s[0] for s in pos_tags if s[1].startswith('N')])
review_brunch['processed_text'] = review_brunch['processed_text'].apply(lambda x: get_noun(x))


def format_sentence(text):
    return {word: True for word in text.split()}

review_brunch['format_sent'] = review_brunch['processed_text'].apply(lambda x: format_sentence(x))
review_brunch['combined'] = review_brunch[['format_sent', 'target']].values.tolist()
review_brunch.head()

pos = []
neg = []
for i in range(len(review_brunch)):
    if review_brunch.target[i] == 'negative':
        neg.append(review_brunch.combined[i])
    else:
        pos.append(review_brunch.combined[i])

# next, split labeled data into the train and test data
train = pos[:int((.9)*len(pos))] + neg[:int((.9)*len(neg))]
test = pos[int((.9)*len(pos)):] + neg[int((.9)*len(neg)):]


nb_classifier = NaiveBayesClassifier.train(train)
nb_classifier.show_most_informative_features(1000)
me_classifier = MaxentClassifier.train(train, algorithm='megam', trace=0, max_iter=1000, min_lldelta=0.5)
accuracy(me_classifier, test)  # 0.9
me_classifier.show_most_informative_features(1000)
