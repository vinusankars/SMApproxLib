#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Oct 11 18:37:20 2018

@author: vinusankars
"""

import pandas as pd
import numpy as np
import tensorflow as tf

#Reading dataset
print('Reading dataset...')
train_data = pd.read_csv('isolet1+2+3+4.data')
test_data = pd.read_csv('isolet5.data')

x, y_true = np.zeros((1,617)), np.zeros(1, dtype='int')
temp = list(train_data)
temp = [float('.'.join(i.split('.')[:2])) for i in temp]
x[0] = np.array(temp[:617], dtype='float64')
y_true[0] = int(temp[-1])-1

x_test, y_test = np.zeros((1,617)), np.zeros(1, dtype='int')
temp = list(test_data)
temp = [float('.'.join(i.split('.')[:2])) for i in temp]
x_test[0] = np.array(temp[:617], dtype='float64')
y_test[0] = int(temp[-1])-1

for i,j in train_data.iterrows():
    temp = np.array(list(j))
    x = np.append(x, [temp[:617]], axis=0)
    y_true = np.append(y_true, [int(temp[-1])-1], axis=0)

for i,j in test_data.iterrows():
    temp = np.array(list(j))
    x_test = np.append(x_test, [temp[:617]], axis=0)
    y_test = np.append(y_test, [int(temp[-1])-1], axis=0)

yt = np.zeros((len(y_true), 26))
yt[np.arange(len(y_true)), y_true] = 1
y_true = yt

yt = np.zeros((len(y_test), 26))
yt[np.arange(len(y_test)), y_test] = 1
y_test = yt
 
def wt(shape, name, i=0.01):
    initial = tf.truncated_normal(shape, stddev=i)
    return tf.Variable(initial, name=name)

def bias(shape, name, i=0.0):
    initial = tf.truncated_normal(shape, stddev=i)
    return tf.Variable(initial, name=name)

graph = tf.Graph()
bs = 50
W1, W2, W3, B1, B2, B3 = 0, 0, 0, 0, 0, 0

#defining NN layers
with graph.as_default():     
    X = tf.placeholder(tf.float32, shape=[None, 617])
    y_ = tf.placeholder(tf.float32, shape=[None, 26], name='y_')
    
    with tf.name_scope('h1'):
        w1 = wt([617, 500], 'w1')
        b1 = bias([500], 'b1')
        h1 = tf.nn.sigmoid(tf.matmul(X, w1) + b1)
   
    with tf.name_scope('h2'):
        w2 = wt([500, 500], 'w2')
        b2 = bias([500], 'b2')
        h2 = tf.nn.sigmoid(tf.matmul(h1, w2) + b2)    
        
    with tf.name_scope('y'):
        w3 = wt([500, 26], 'w3')
        b3 = bias([26], 'b3')
        y = tf.nn.sigmoid(tf.matmul(h2, w3) + b3)    
        
    with tf.name_scope('cost'):
        cross_entropy = tf.reduce_mean(
                tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y))
        
    with tf.name_scope('train'):
        train_step = tf.train.AdamOptimizer(learning_rate=0.001).minimize(cross_entropy)
        
    with tf.name_scope('acc'):
        predn = tf.equal(tf.argmax(y, 1), tf.argmax(y_, 1))
        acc = tf.reduce_mean(tf.cast(predn, tf.float32))

with tf.Session(graph=graph) as sess:     
    sess.run(tf.global_variables_initializer())
    for itr in range(500):
        for i in range(0, 60000, bs):        
            train_step.run(feed_dict={X: x[i: i+bs], y_: y_true[i: i+bs]})    
        
#            if i%500 == 0 and i>0:
#                print(i, sess.run(cross_entropy, feed_dict={X:x[i-50:i] ,y_:y_true[i-50:i]}))
        
        feed_dict={X: x, y_: y_true}
        ac = acc.eval(feed_dict=feed_dict)
        print("Itr: %3d, Accuracy: %.5f" % (itr+1,ac*100))
        
        # if ac > 0.955:
        #     W1 = w1.eval()
        #     W2 = w2.eval()
        #     W3 = w3.eval()
        #     B1 = b1.eval()
        #     B2 = b2.eval()
        #     B3 = b3.eval()
        #     feed_dict={X: x_test, y_: y_test}
        #     ac = acc.eval(feed_dict=feed_dict)
        #     print("Test Accuracy: %.5f" % (ac*100))
        #     if ac>0.94:
        #         break
            