#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep  9 21:07:50 2018

@author: vinusankars
"""

import pickle
import numpy as np
from mlxtend.data import loadlocal_mnist #To import dataset
import cfpm_wrapper

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

#Input x=dataset_input(?, 784), z=Actual_output(?,10)
#If z is not passed, the function is meant to return output array, esle accuracy
def test(x, z=[]):
    if len(z) == 0:
        Y = np.zeros(x.shape)
    c, w = 0, 0
    for i in range(len(x)):
        if i%50==0:
            print(i)
        h = sigmoid(matmul(w1, x[i]) + b1)     
        y = sigmoid(matmul(w2, h) + b2)
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
           
x_test, y_test = loadlocal_mnist(images_path='t10k-images-idx3-ubyte',
                       labels_path='t10k-labels-idx1-ubyte')

#y = np.zeros((len(y_test), 10))
#y[np.arange(len(y_test)), y_test] = 1
#y_test = y

with open('mnist_weights.pckl', 'rb') as f:
    w1, b1, w2, b2 = pickle.load(f)

w1 = w1.T
w2 = w2.T

print('\nAccuracy: '+ str(test(x_test, y_test))+'%')