import numpy as np
import pdb

class Layer:
  limit = 0.5
  def __init__(self, input_count, output_count, prev_layer, inputs, act_fn, act_fn_derivative):
    self._inputs = inputs
    self.limit = (1/np.sqrt(input_count + 1))
    if inputs is not None:
      self._extended_inputs = self.add_threshold(inputs)

    self.weights = ((np.random.rand(input_count + 1, output_count)*2*self.limit) - self.limit if output_count != 0 else None)
    self.prev_layer = prev_layer
    self.act_fn = np.vectorize(act_fn)
    self.act_fn_derivative = np.vectorize(act_fn_derivative)
    self.next_layer = None
    self.outputs = None
    self.deltas = None
    self.prev_deltas_w = None
    self._prev_weights = None

  def add_threshold(self, inputs):
    a = np.empty(inputs.shape[0])
    a.fill(-1)
    return np.column_stack((a, inputs))

  def calc_outputs(self):
    if self.prev_layer:
      self.outputs = self.add_threshold(self.act_fn(self.inputs))
    else:
      self.outputs = self._extended_inputs
    if self.next_layer:
      self.next_layer.inputs = self.outputs.dot(self.weights)
    else:
      self.outputs = (self.inputs)

  def calc_delta(self, expected_outputs):
    if self.next_layer is not None:
      new_deltas = self.next_layer.deltas.dot(self.weights[1:].T)
      self.deltas = self.act_fn_derivative(self.inputs)*new_deltas
    else:
      self.deltas = (expected_outputs - self.outputs)

  def save_weights(self):
    if self.weights is None:
      return
    self._prev_weights = self.weights

  def restore_weights(self):
    if self.weights is None or self._prev_weights is None:
      return
    self.weights = self._prev_weights

  @property
  def inputs(self):
      return self._inputs

  @inputs.setter
  def inputs(self, new_inputs):
    if new_inputs is not None:
      self._inputs = new_inputs
      self._extended_inputs = self.add_threshold(new_inputs)

