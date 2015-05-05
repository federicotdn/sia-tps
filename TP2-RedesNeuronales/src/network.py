import layer as L
import numpy as np
import pdb
from pylab import *
import time

class Network:
  def __init__(self, config, inputs, expected_outputs, act_fn, act_fn_derivative, eta, min_cuadratic_error, alpha, beta, m_alpha):
    self._eta = eta
    self._alpha = alpha
    self._beta = beta
    self._m_alpha = m_alpha
    self._min_cuadratic_error = min_cuadratic_error

    self._inputs = inputs
    self._config = config
    self._current_layer = L.Layer(inputs.shape[1], config[0], None, inputs, act_fn, act_fn_derivative)
    self._input_layer = self._current_layer
    prev_layer = self._current_layer
    for i, j in zip(config, (config + [expected_outputs.shape[1]])[1:]):
      layer = L.Layer(i, j, prev_layer, None, act_fn, act_fn_derivative)
      prev_layer = layer

    self._output_layer = L.Layer(expected_outputs.shape[1], 0, layer, None, act_fn, act_fn_derivative)

    layer = self._output_layer
    while prev_layer:
      prev_layer.next_layer = layer
      layer = prev_layer
      prev_layer = prev_layer.prev_layer

    self._expected_outputs = expected_outputs
    self._outputs = np.zeros(self._expected_outputs.shape)
    self._current_expected_outputs = None
    self._fn_fig = figure()
    self._e_fig = figure()

  def train(self, epochs, incremental):
    finished = False
    max_epochs = epochs
    self._epochs_arr = []
    self._cuadratic_error_arr = []
    ion()
    prev_cuadratic_error = 0
    while not finished:
      if incremental:
        order = np.arange(len(self._inputs))
        np.random.shuffle(order)
        for i in order:
          self._current_layer.inputs = np.array([self._inputs[i]])
          self._current_expected_outputs = np.array([self._expected_outputs[i]])
          self._run(incremental, i)
        #self._go_forward()
      else:
        self._current_expected_outputs = self._expected_outputs
        self._run(incremental, None)


      self._cuadratic_error = (1.0/self._inputs.shape[0]) * (np.power((self._expected_outputs - self._outputs), 2).sum())

      self._epochs_arr.append(max_epochs - epochs)
      self._cuadratic_error_arr.append(self._cuadratic_error)

      if epochs == 0:
        prev_cuadratic_error = self._cuadratic_error


      if self._beta != 0 and epochs % 1 == 0:
        delta_E = self._cuadratic_error - prev_cuadratic_error
        prev_cuadratic_error = self._cuadratic_error
        delta_eta = 0
        if delta_E < 0:
          delta_eta = self._alpha
          self._save_weights()
        else:
          delta_eta = (- self._beta) * self._eta
          self._restore_weights()

        self._eta += delta_eta

      if epochs % 10 == 0:
        print('E = ' + str(self._cuadratic_error) + '  epoca: ' + str(max_epochs - epochs))
        self._draw_fn(False, False, True)

      finished = (True if epochs == 0 or self._cuadratic_error <= self._min_cuadratic_error else False)

      if finished:
        self._input_layer.inputs = self._inputs
        self._go_forward()
        self._finished(max_epochs - epochs, False)
        return

      epochs-=1

  def _run(self, incremental, index):
    self._go_forward()

    if incremental:
      self._outputs[index] = self._current_layer.outputs
    else:
      self._outputs = self._current_layer.outputs
  
    self._backPropagate()
    

  def _backPropagate(self):
    self._current_layer = self._output_layer
    while self._current_layer.prev_layer:
      self._current_layer.calc_delta(self._current_expected_outputs)
      self._current_layer = self._current_layer.prev_layer

    self._current_layer = self._output_layer
    while self._current_layer.prev_layer:
      deltas_w = ((self._eta) * self._current_layer.prev_layer.outputs.T.dot(self._current_layer.deltas)) + ((self._m_alpha * self._current_layer.prev_layer.prev_deltas_w) if self._current_layer.prev_layer.prev_deltas_w is not None else 0)
      self._current_layer.prev_layer.prev_deltas_w = deltas_w
      self._current_layer.prev_layer.weights += deltas_w 
      if self._current_layer.next_layer:
        self._current_layer.next_layer.deltas = None
      self._current_layer = self._current_layer.prev_layer

  def test(self, inputs, expected_outputs):
    self._inputs = inputs
    self._expected_outputs = expected_outputs
    self._current_layer = self._input_layer
    self._current_layer.inputs = inputs
    self._go_forward()
    self._outputs = self._current_layer.outputs
    self._finished(None, True)
  
  def _go_forward(self):
    self.current_layer = self._input_layer
    while self._current_layer:
      self._current_layer.calc_outputs()
      self._current_layer = self._current_layer.next_layer

    self._current_layer = self._output_layer

  def _finished(self, epochs, test):
    self._cuadratic_error = (1.0/self._inputs.shape[0]) * (np.power((self._expected_outputs - self._outputs), 2).sum())
    self._draw_fn(test, True, False)
    print('\nConfig: ' + str(self._config))
    print('\neta: ' + str(self._eta))
    print('\nerror: ' + str(self._cuadratic_error))
    print('\nepocas: ' + str(epochs))


  def _apply_fn(self, layer, fn):
    if layer is None:
      return
    fn(layer)
    self._apply_fn_forward(layer.next_layer, fn)

  def _save_weights(self):
    current_layer = self._input_layer
    while current_layer:
      current_layer.save_weights()
      current_layer = current_layer.next_layer

  def _restore_weights(self):
    current_layer = self._input_layer
    while current_layer:
      current_layer.restore_weights()
      current_layer = current_layer.next_layer

  def _draw_fn(self, test, use_time, draw_error):
    self._fn_fig.clf()
    self._e_fig.clf()
    r = self._inputs.reshape(len(self._inputs))
    o = self._outputs.reshape(len(self._outputs))
    e_o = self._expected_outputs.reshape(len(self._expected_outputs))
    
    ax1 = self._fn_fig.add_subplot(111)
    ax1.plot(r, o, color = 'b', label = 'salida calculada')
    ax1.plot(r, e_o, color = 'r', label = 'salida esperada')
    ax1.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3, ncol=2, mode="expand", borderaxespad=0.)
    name = str(self._config) +  ('-momentum' if self._m_alpha != 0 else '') + ('-adaptative' if  self._beta else '-eta=' + str(self._eta)) + ('-test' if test else '')  + ('-' + str(time.time()) if use_time else '')
    self._fn_fig.savefig(name + '-FUNCTION.png')
    if draw_error:
      ax2 = self._e_fig.add_subplot(111)
      ax2.plot(self._epochs_arr, self._cuadratic_error_arr, color = 'b', label = 'Error cuadrático medio')
      self._e_fig.savefig(name + '-ERROR.png')

