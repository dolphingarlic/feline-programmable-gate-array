from python_speech_features import mfcc, delta
import matplotlib.pyplot as plt
import scipy.io.wavfile as wav
import numpy as np
from sklearn.svm import OneClassSVM
from sklearn.mixture import GaussianMixture

WINDOW_WIDTH = 10

def compute_features(signal, rate):
    mfcc_feat = mfcc(signal, rate, winfunc=np.hamming)
    d_mfcc_feat = delta(mfcc_feat, 1)
    raw_feat = np.concatenate((mfcc_feat, d_mfcc_feat), axis=1)
    # mean = np.mean(raw_feat, axis=0)
    # sd = np.std(raw_feat, axis=0)
    # return (raw_feat - mean) / sd
    return raw_feat
    # return mfcc_feat


def read_and_predict(filename, svm_model):
    rate, signal = wav.read(filename)
    features = compute_features(signal, rate)
    prediction = svm_model.predict(features)
    plt.plot(prediction)
    plt.show()


# Extract MFCC features from training data
# rate, signal = wav.read('example_data/silence.wav')  # 16KHz sample rate
# print(rate)
# features = compute_features(signal, rate)
# print(features.shape)

# plt.imshow(np.transpose(features), aspect='auto', interpolation=None)
# plt.figure(1, figsize=(5, 10))
# plt.show()

rate, signal = wav.read('example_data/nopauses.wav')  # 16KHz sample rate
print(rate)
features = compute_features(signal, rate)
print(features.shape)

plt.imshow(np.transpose(features), aspect='auto', interpolation=None)
plt.figure(1, figsize=(5, 10))
plt.show()

# Train model
svm_model = OneClassSVM(kernel='linear', nu=0.1).fit(features)
gmm_model = GaussianMixture().fit(features)
print(len(svm_model.support_vectors_), 'support vectors')
prediction = svm_model.predict(features)
plt.plot(prediction, label='Idk')
plt.show()

# Test predicting positives
# read_and_predict('example_data/andi_test.wav', svm_model)
read_and_predict('example_data/snaps_clicks.wav', svm_model)
read_and_predict('example_data/aaa.wav', svm_model)
# read_and_predict('example_data/andi_test.wav', svm_model)
read_and_predict('example_data/silence.wav', svm_model)
read_and_predict('example_data/andi_clean.wav', svm_model)
# rate, signal = wav.read()
# features = compute_features(signal, rate)
# prediction = svm_model.predict(features)
# cumsum_vec = np.cumsum(np.insert(prediction, 0, 0))
# ma_vec = (cumsum_vec[WINDOW_WIDTH:] - cumsum_vec[:-WINDOW_WIDTH]) / WINDOW_WIDTH
# plt.plot(prediction, label='Idk')
# plt.plot(ma_vec, label="Prediction")
# plt.show()
