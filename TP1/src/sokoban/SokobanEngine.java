package sokoban;

import gps.GPSEngine;
import gps.GPSNode;
import gps.api.GPSState;

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
			break;
		default:
			throw new RuntimeException("Invalid Strategy");
		}

	}
	
	private void addNodeGreedy(GPSNode node) {
		int hValue = problem.getHValue(node.getState());
		int i = 0;
		
		for (; i < open.size(); i++) {
			GPSState state = open.get(i).getState();
			int otherValue = problem.getHValue(state);
			if (otherValue >= hValue) {
				break;
			}
		}
		
		open.add(i, node);
	}
	
	private void addNodeAStar(GPSNode node) {
		int fValue = problem.getHValue(node.getState()) + node.getCost();
		int i = 0;
		
		for (; i < open.size(); i++) {
			GPSNode otherNode = open.get(i);
			int otherValue = problem.getHValue(otherNode.getState()) + otherNode.getCost();
			if (otherValue >= fValue) {
				break;
			}
		}
		
		open.add(i, node);
	}

	private void addNodeBFS(GPSNode node) {
		open.add(node);
	}
	
	private void addNodeDFS(GPSNode node) {
		open.add(0, node);
	}
}
