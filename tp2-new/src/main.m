source('network.m');

network = init_network();
network = train(network, true);
pause();
