#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Sep  6 11:27:12 2018

@author: vinusankars
"""

import tensorflow as tf
from mlxtend.data import loadlocal_mnist
import numpy as np
#import pickle

x, y_true = loadlocal_mnist(images_path='train-images-idx3-ubyte',
                       labels_path='train-labels-idx1-ubyte')

x_test, y_test = loadlocal_mnist(images_path='t10k-images-idx3-ubyte',
                       labels_path='t10k-labels-idx1-ubyte')

y = np.zeros((len(y_true), 10))
y[np.arange(len(y_true)), y_true] = 1
y_true = y

y = np.zeros((len(y_test), 10))
y[np.arange(len(y_test)), y_test] = 1
y_test = y

x, x_test, y_true, y_test = np.array(x, dtype='float32'),np.array(x_test, dtype='float32'),np.array(y_true, dtype='float32'),np.array(y_test, dtype='float32')

def wt(shape, name, i=0.01):
    initial = tf.truncated_normal(shape, stddev=i)
    return tf.Variable(initial, name=name)

def bias(shape, name, i=0.0):
    initial = tf.truncated_normal(shape, stddev=i)
    return tf.Variable(initial, name=name)

graph = tf.Graph()
bs = 50
W1, W2, B1, B2 = 0, 0, 0, 0

#defining NN layers
with graph.as_default():     
    X = tf.placeholder(tf.float32, shape=[None, 784])
    y_ = tf.placeholder(tf.float32, shape=[None, 10], name='y_')
    
    with tf.name_scope('h'):
        w1 = wt([784, 800], 'w1')
        b1 = bias([800], 'b1')
        h = tf.nn.sigmoid(tf.matmul(X, w1) + b1)
   
    with tf.name_scope('y'):
        w2 = wt([800, 10], 'w2')
        b2 = bias([10], 'b2')
        y = tf.nn.sigmoid(tf.matmul(h, w2) + b2)    
        
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
        
        if ac > 0.96:
            W1 = w1.eval()
            W2 = w2.eval()
            B1 = b1.eval()
            B2 = b2.eval()
        
#with open('wb.pckl', 'wb') as f:
#    pickle.dump([W1, B1, W2, B2], f)