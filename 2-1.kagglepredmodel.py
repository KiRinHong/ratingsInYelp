import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score
from keras.preprocessing.text import Tokenizer
from keras.preprocessing.sequence import pad_sequences
from keras.models import Model
from keras.layers import Dense, Input, Embedding, LSTM, Dropout
from keras.utils import to_categorical
from keras.callbacks import ModelCheckpoint

review_category = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_train_clean.csv',
 lineterminator='\n', index_col = 0)
review_category = review_category.drop(['business_id', 'date'], axis = 1)
review_category = review_category.dropna().reset_index()
review_category[review_category.isnull().any(axis=1)]
review_category['target'] = review_category.stars.astype('category').cat.codes
review_category['stars'].value_counts()

review_category['num_words'] = review_category.processed_text.apply(lambda x: len(x.split()))
review_category['bins']=pd.cut(review_category.num_words, bins=[0,100,150,200,300, np.inf],
                                labels=['0-100', '100-150', '150-200', '200-300', '>300'])
word_dist = review_category.groupby('bins').size().reset_index().rename(columns={0:'counts'})
word_dist.head()
num_class = len(np.unique(review_category.stars.values))
y = review_category['target'].values
MAX_LENGTH = 150
tokenizer = Tokenizer()
# creates the vocabulary index based on word frequency
tokenizer.fit_on_texts(review_category.processed_text.values) # attributes: word_counts, document_count, word_index, word_docs
# Transforms each text in texts to a sequence of integers
# basically takes each word in the text and replaces it with its corresponding integer value from the word_index dictionary
post_seq = tokenizer.texts_to_sequences(review_category.processed_text.values)
# ensure that all sequences in a list have the same length
# by padding 0 in the beginning of each sequence
post_seq_padded = pad_sequences(post_seq, maxlen = MAX_LENGTH)
post_seq_padded.shape
del review_category # free memory
X_train, X_test, y_train, y_test = train_test_split(post_seq_padded, y, test_size=0.1)
vocab_size = len(tokenizer.word_index) + 1

inputs = Input(shape=(MAX_LENGTH, ))
embedding_layer = Embedding(vocab_size, 128, input_length=MAX_LENGTH)(inputs)
x = LSTM(64, return_sequences=True, recurrent_dropout=0.5)(embedding_layer)
x = Dropout(0.5)(x)
x = LSTM(64, recurrent_dropout=0.5)(x)
x = Dense(64, activation='relu')(x)
predictions = Dense(num_class, activation='softmax')(x)
model = Model(inputs=[inputs], outputs=predictions)
model.compile(loss="mean_squared_error", optimizer="rmsprop", metrics=['mse'])
# another optimizer
# model.compile(optimizer='adam',
#               loss='categorical_crossentropy',
#               metrics=['acc'])
model.summary()
filepath="rmse_dropout_weights.hdf5"
checkpointer = ModelCheckpoint(filepath, monitor='val_mean_squared_error', verbose=1, save_best_only=True, mode='min')
history = model.fit([X_train], batch_size=64, y=to_categorical(y_train), verbose=1, validation_split=0.1,
          shuffle=True, epochs=3, callbacks=[checkpointer])

model.load_weights('rmse_dropout_weights.hdf5')
predicted = model.predict(X_test)
predicted[0]
predicted = np.argmax(predicted, axis=1)
rmse = np.sqrt(((predicted - y_test) ** 2).mean(axis=0))
rmse

review_test = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_test_clean.csv', lineterminator='\n', index_col=0)
review_test = review_test.drop(['business_id', 'date'], axis = 1)
review_test.shape
review_test['processed_text'] = review_test['processed_text'].apply(lambda x: str(x))
post_seq_test = tokenizer.texts_to_sequences(review_test.processed_text.values)
post_seq_padded_test = pad_sequences(post_seq_test, maxlen=MAX_LENGTH)
model.load_weights('rmse_dropout_weights.hdf5')
len(post_seq_test)
post_seq_padded_test.shape
predicted_test = model.predict(post_seq_padded_test)
predicted_test = np.argmax(predicted_test, axis=1)
predicted_test = predicted_test+1
# double check the dimensions
review_test.shape
review_test['expected'] = predicted_test
review_test.to_csv('~/Documents/STAT628/ratingsInYelp/data/review_test_results_rmsedropout.csv')








# accuracy
filepath="weights.hdf5"
checkpointer = ModelCheckpoint(filepath, monitor='val_acc', verbose=1, save_best_only=True, mode='max')
history = model.fit([X_train], batch_size=64, y=to_categorical(y_train), verbose=1, validation_split=0.1,
          shuffle=True, epochs=5, callbacks=[checkpointer])

model.load_weights('weights.hdf5')
predicted = model.predict(X_test)
predicted = np.argmax(predicted, axis=1)
accuracy_score(y_test, predicted)

review_test = pd.read_csv('~/Documents/STAT628/ratingsInYelp/data/review_test_clean_v2.csv', lineterminator='\n', index_col=0)
review_test = review_test.drop(['business_id', 'date'], axis = 1)
review_test['lower_text'] = review_test['lower_text'].apply(lambda x: str(x))
len(review_test.lower_text.values)
post_seq_test = tokenizer.texts_to_sequences(review_test.lower_text.values)
post_seq_padded_test = pad_sequences(post_seq_test, maxlen=MAX_LENGTH)
model.load_weights('weights.hdf5')
len(post_seq_test)
post_seq_padded_test.shape
predicted_test = model.predict(post_seq_padded_test)
predicted_test = np.argmax(predicted_test, axis=1)
predicted_test = predicted_test+1
review_test.shape
review_test['expected'] = predicted_test
review_test.head()
review_test.to_csv('~/Documents/STAT628/ratingsInYelp/data/review_test_results.csv')

predicted_test[review_test.isnull().any(axis=1)]



from imblearn.over_sampling import SMOTE
smote = SMOTE('minority')
X_sm, y_sm = smote.fit_sample(X_train, y_train)
X_sm.shape
X_train.shape
filepath="weights_smote.hdf5"
checkpointer = ModelCheckpoint(filepath, monitor='val_acc', verbose=1, save_best_only=True, mode='max')
history = model.fit([X_sm], batch_size=64, y=to_categorical(y_sm), verbose=1, validation_split=0.25,
          shuffle=True, epochs=10, callbacks=[checkpointer])









labels = y.astype('category')
labels.cat.categories
counts = y.value_counts()
counts
labeled_words = [(l) for l in labels]

def high_information_words(labelled_words, score_fn=BigramAssocMeasures.chi_sq, min_score=5):
    # count the frequency of every word, as well as the conditional frequency for each word within each label
    # n_ii: This is the frequency of the word for the label
    # n_ix: This is the total frequency of the word across all labels
    # n_xi: This is the total frequency of all words that occurred for the label
    # n_xx: This is the total frequency of all words in all labels
    # the closer n_ii is to n_ix, the higher the score
    # keep the words that meet or exceed the threshold and return all high scoring words in each label
    word_fd = FreqDist()
    label_word_fd = ConditionalFreqDist()
    for label, words in labelled_words:
        for word in words:
            word_fd[word] += 1
            label_word_fd[label][word] += 1
    n_xx = label_word_fd.N()
    high_info_words = set()
    for label in label_word_fd.conditions():
        n_xi = label_word_fd[label].N()
        word_scores = collections.defaultdict(int)
        for word, n_ii in label_word_fd[label].items():
            n_ix = word_fd[word]
            score = score_fn(n_ii, (n_ix, n_xi), n_xx)
            word_scores[word] = score
        bestwords = [word for word, score in word_scores.items() if score >= min_score]
        high_info_words |= set(bestwords)
    return high_info_words


def bag_of_words_in_set(words, goodwords):
    # filter out all low information words
    return bag_of_words(set(words) & set(goodwords))


movie_reviews.words(categories=['pos'])
