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
