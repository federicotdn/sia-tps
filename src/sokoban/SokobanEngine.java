package sokoban;

import gps.GPSEngine;
import gps.GPSNode;

public class SokobanEngine extends GPSEngine {

	@Override
	public void addNode(GPSNode node) {
		switch (strategy) {
		case AStar:
			addNodeAStar(node);
			break;
		case BFS:
			addNodeBFS(node);
			break;
		case DFS:
			addNodeDFS(node);
			break;
		case Greedy:
			addNodeGreedy(node);
		default:
			throw new RuntimeException("Invalid Strategy");
		}

	}
	
	private void addNodeGreedy(GPSNode node) {
		
	}
	
	private void addNodeAStar(GPSNode node) {
		
	}

	private void addNodeBFS(GPSNode node) {
		open.add(node);
	}
	
	private void addNodeDFS(GPSNode node) {
		open.add(0, node);
	}	
}
