package sokoban.heuristics;

import java.util.ArrayList;

import sokoban.Board;
import sokoban.BoardEntity;
import sokoban.Cell;

public class DistanceOnlyHeuristic extends SokobanHeuristic {

	private final boolean closestOnly;
	
	public DistanceOnlyHeuristic(boolean closestOnly) {
		this.closestOnly = closestOnly;
	}
	
	@Override
	protected Integer calculateHValue(Board board) {
		ArrayList<Cell> chests = board.getChests();
		ArrayList<Cell> goals = board.getGoals();
		int manhattan = 0;
		
		for (Cell goal : goals) {
			if (goal.getBoardEntity() == BoardEntity.CHEST) {
				/*
				 * Si el goal ya tiene una caja arriba, no sumar a la distancia.
				 */
				continue;
			}
			
			if (closestOnly) {
				manhattan += getMinimumDistanceFor(chests, goal);
			} else {
				manhattan += getTotalDistanceFor(chests, goal);
			}
		}
		
		return manhattan;
	}
	
	private int getTotalDistanceFor(ArrayList<Cell> chests, Cell goal) {
		int total = 0;
		for (Cell chest : chests) {
			total += getMDistance(chest, goal);
		}
		return total;
	}
	
	private int getMinimumDistanceFor(ArrayList<Cell> chests, Cell goal) {
		Integer minDist = null;
		for (Cell chest : chests) {
			int dist = getMDistance(chest, goal);
			if (minDist == null || dist < minDist) {
				minDist = dist;
			}
		}
		return minDist;
	}

	private int getMDistance(Cell chest, Cell goal) {
		int x = Math.abs(chest.getX() - goal.getX());
		int y = Math.abs(chest.getY() - goal.getY());
		return (int)Math.sqrt((Math.pow(x, 2) + Math.pow(y, 2)));
	}

}
