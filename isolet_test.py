#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 11 20:05:34 2018

@author: vinusankars
"""

import pickle
import numpy as np
import pandas as pd
import cfpm_wrapper

print('Reading dataset...')
test_data = pd.read_csv('isolet5.data')

x_test, y_test = np.zeros((1,617)), np.zeros(1, dtype='int')
temp = list(test_data)
temp = [float('.'.join(i.split('.')[:2])) for i in temp]
x_test[0] = np.array(temp[:617], dtype='float64')
y_test[0] = int(temp[-1])-1

for i,j in test_data.iterrows():
    temp = np.array(list(j))
    x_test = np.append(x_test, [temp[:617]], axis=0)
    y_test = np.append(y_test, [int(temp[-1])-1], axis=0)

#Sigmoid function
def sigmoid(x):
    return 1/(1+np.exp(-x))

#Multiplication unit
def matmul(w, x):
    wx = np.zeros(w.shape[0])
    if w.shape[1] == len(x):
        for i in range(w.shape[0]):
            for j in range(w.shape[1]):
                wx[i] += cfpm_wrapper.cfpm(w[i][j],x[j],5) #Element-wise multiplication
        return wx
    else:
        return -1
    
def test(x, z=[]):
    if len(z) == 0:
        Y = np.zeros(x.shape)
    c, w = 0, 0
    for i in range(len(x[:200])):
        if i%50==0:
            if i!=0:
                print(i, c/(c+w)*100,'%')
            else:
                print(i)
        h1 = sigmoid(matmul(w1, x[i]) + b1) 
        h2 = sigmoid(matmul(w2, h1) + b2) 
        y = sigmoid(matmul(w3, h2) + b3)
        if len(z) != 0:
            if np.argmax(y) == z[i]:
                c += 1
            else: 
                w += 1
        else:
            Y[i] = np.argmax(y)
    if len(z) == 0:
        return Y
    else:
        return c/(c+w)*100
    
with open('isolet_weights.pckl', 'rb') as f:
    w1, w2, w3, b1, b2, b3 = pickle.load(f)
    
w1 = w1.T
w2 = w2.T
w3 = w3.T
b1 = b1.T
b2 = b2.T
b3 = b3.T
    
print('\nAccuracy: '+ str(test(x_test, y_test))+'%')