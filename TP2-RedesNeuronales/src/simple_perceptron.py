import numpy as np
import pdb

class simple_perceptron(object):
  eta = 0.05
  def __init__(self, inputs, expected_outputs, actfun):
    self.inputs = inputs
    self.extended_inputs = self.add_threshold()
    self.expected_outputs = expected_outputs
    self.actfun = np.vectorize(actfun)
    self.weights = np.random.rand(self.extended_inputs.shape[1], 1)

  def add_threshold(self):
    a = np.empty(self.inputs.shape[0])
    a.fill(-1)
    return np.column_stack((a, self.inputs))

  def learn(self):
    print('Aprendiendo \n')
    learned = False
    i = 0
    while not learned:
      i+= 1
      outputs = self.extended_inputs.dot(self.weights)
      outputs = self.actfun(outputs)
      if (outputs == self.expected_outputs).all():
        learned = True
      deltas = self.extended_inputs.T.dot((self.expected_outputs - outputs)*self.eta)
      self.weights = deltas + self.weights
      print(np.column_stack((self.inputs, outputs)))
      print('\n')

    print('Aprendido despues de ' + str(i) + ' intentos')

