import simple_perceptron as sp
import numpy as np
import network as nw
import activation_function as act_fn_mod
from pylab import *
import pdb

def _parse_int(s):
  try:
    return int(s)
  except ValueError:
    return 0

def _parse_float(s):
  try:
    return float(s)
  except ValueError:
    return 0.0

def _get_range():
  print('\nrango: ')
  r_input = input()
  r_input =  [_parse_float(n) for n in r_input.split(',')]
  while len(r_input) != 3:
    print('rango invalido. Introduzca \'min, max, incremento\'')
    r_input = input()
    r_input =  [_parse_float(n) for n in r_input.split(',')]
  return r_input

def main():
  print('Red neuronal')
  network = None
  while True:
    print('1. Entrenar')
    print('2. Correr')
    option = _parse_int(input())
    if option == 1:
      print('Indroduzca los siguientes parametros: \n')
      print('arquitectura: ')
      architecture = input()
      architecture = [_parse_int(n) for n in architecture.split(',')]
      while len(architecture) < 1 or architecture[0] == 0:
        print('arquitectura: ')
        architecture = input()
        architecture = [_parse_int(n) for n in architecture.split(',')]
      print('\neta: ')
      eta = float(input())
      print('\nerror cuadratico medio de corte: ')
      min_cuadratic_error = float(input())
      print('\nalfa: ')
      alpha = float(input())
      print('\nbeta: ')
      beta = float(input())
      print('\nalfa momentum: ')
      alpha_momentum = float(input())
      r_input = _get_range()
      print('\n Funcion de activacion: ')
      print('\n 1. tanh')
      print('\n 2. exponencial')
      error = True
      while error:
        act_fn_input = _parse_int(input())
        if act_fn_input == 1:
          act_fn = act_fn_mod.tanh_fn
          act_fn_derivative = act_fn_mod.tanh_fn_derivative
          error = False
        elif act_fn_input == 2:
          act_fn = act_fn_mod.exponential_fn
          act_fn_derivative = act_fn_mod.exponential_fn_derivative
          error = False
        else:
          error = True
          print('Valor invalido')
      print('\nEpocas: ')
      epochs = _parse_int(input())
      if epochs == 0:
        epochs = 50000

      
      r = arange(r_input[0], r_input[1], r_input[2])
      expected_outputs = ((sin(r)*(r**3)) + (r/2))
      max_num = max(np.amax(expected_outputs), abs(np.amin(expected_outputs)))
      expected_outputs = expected_outputs/max_num
      expected_outputs =  expected_outputs.reshape(len(expected_outputs), 1)
      network = nw.Network(architecture, r.reshape(len(r), 1), expected_outputs, act_fn, act_fn_derivative, eta, min_cuadratic_error, alpha, beta, alpha_momentum)
      network.train(epochs, True)
    elif option == 2:
      if not network:
        print("La red no ha sido creada.\n")
        continue
      r_input = _get_range()
      r = arange(r_input[0], r_input[1], r_input[2])
      expected_outputs = ((sin(r)*(r**3)) + (r/2))
      expected_outputs =  expected_outputs.reshape(len(expected_outputs), 1)
      max_num = max(np.amax(expected_outputs), abs(np.amin(expected_outputs)))
      expected_outputs = expected_outputs/max_num
      network.test(r.reshape(len(r), 1), expected_outputs)

    else:
      print('Comando invalido')

if __name__ == '__main__':
    main()

