import pandas as pd
import re
import string
from nltk import pos_tag
from nltk.corpus import wordnet
from nltk.stem import WordNetLemmatizer
import nltk
nltk.download('averaged_perceptron_tagger')


# replacing words matching regular expressions
def replace_patterns(text):
    patterns = [
        (r'won\'t', 'will not'),
        (r'can\'t', 'cannot'),
        (r'i\'m', 'i am'),
        (r'ain\'t', 'is not'),
        (r'(\w+)\'ll', '\g<1> will'),  # \w+ any word characters; \g<1> where 1 is the number of a capturing group
        (r'(\w+)n\'t', '\g<1> not'),
        (r'(\w+)\'ve', '\g<1> have'),
        (r'(\w+)\'re', '\g<1> are'),
        (r'(\w+)\'s', '\g<1> is'),
        (r'(\w+)\'d', '\g<1> would'),
        (r'(\n)', ' ')  # replace new line with space
    ]
    attributes = [(re.compile(regex), repl) for (regex, repl) in patterns]
    s = str(text)
    for (pattern, repl) in attributes:
        s = re.sub(pattern, repl, s)
    return s


# removing repeating characters
def replace_repeater(word):
    if wordnet.synsets(word):
        return word
    repl_word = re.sub(r'(\w*)(\w)\2(\w*)', r'\1\2\3', word)
    if repl_word != word:
        return replace_repeater(repl_word)
    else:
        return repl_word


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


# remove stopwoards except not, up, down, only, out
stop_words = ['i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your',
            'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her', 'hers',
            'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs', 'themselves',
            'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those', 'am', 'is',
            'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had', 'having',
            'do', 'does', 'did', 'doing', 'a', 'an', 'the', 'and', 'if', 'or', 'because', 'but',
            'as', 'until', 'while', 'of', 'at', 'by', 'for', 'with', 'about',
            'against', 'between', 'into', 'through', 'during', 'before', 'after',
            'above', 'below', 'in', 'on', 'off', 'over', 'under',
            'again', 'further', 'then', 'once', 'here', 'there', 'when',
            'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few', 'more', 'most', 'nor'
            'other', 'some', 'such', 'own', 'same', 'so', 'than', 'can', 'to', 'from',
            'will', 'just', 'should', 'now', 'm', 'o', 'y']

def clean_text(text):
    # lower text
    text = str(text)
    text = text.lower()
    # replacing words matching regular expressions
    text = replace_patterns(text)
    # tokenize text and remove puncutation: '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
    text = [word.strip(string.punctuation) for word in text.split(" ")]
    # remove words that contain numbers
    text = [word for word in text if not any(c.isdigit() for c in word)]
    # remove replace patterns
    text = [replace_repeater(x) for x in text]
    # remove stop words
    text = [x for x in text if x not in stop_words]
    # remove empty tokens
    text = [t for t in text if len(t) > 0]
    # pos tag text
    pos_tags = pos_tag(text)
    # lemmatize text
    text = [WordNetLemmatizer().lemmatize(t[0], get_wordnet_pos(t[1])) for t in pos_tags]
    # remove words with only one letter
    text = [t for t in text if len(t) > 1]
    # join all
    text = " ".join(text)
    return(text)
review = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_train.csv', encoding = 'utf-8', index_col = 0)
review = review.dropna(how = 'any')

review[pd.isnull(review).any(axis=1)]
review.head()
review["processed_text"] = review["text"].apply(lambda x: clean_text(x))
review = review.drop('text', axis = 1)
review.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_train_clean.csv')


review = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_test.csv', encoding = 'utf-8', index_col = 0)
review = review.dropna(how = 'any')
review[pd.isnull(review).any(axis=1)]
review.head()
review["processed_text"] = review["text"].apply(lambda x: clean_text(x))
review = review.drop('text', axis = 1)
review.to_csv('/home/kirin/Documents/STAT628/ratingsInYelp/data/review_test_clean.csv')



## generate brunch review

id = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/brunch_businessid_LA.csv', index_col = 0)
id = id.x.values.tolist()
id = [float(x) for x in id]
len(id)
review = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_train_clean.csv', lineterminator='\n', index_col = 0)
review_brunch = review.loc[review['business_id'].isin(id)]
review_brunch.shape
review_brunch.to_csv('~/Documents/STAT628/ratingsInYelp/data/review_brunch.csv')
