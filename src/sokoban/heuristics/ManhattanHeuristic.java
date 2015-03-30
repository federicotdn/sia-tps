package sokoban.heuristics;

import java.util.ArrayList;

import sokoban.Board;
import sokoban.BoardEntity;
import sokoban.Cell;
import sokoban.Cell.CellType;

public class ManhattanHeuristic extends SokobanHeuristic {

	private static final Integer MAX_H = Integer.MAX_VALUE;
	
	@Override
	protected Integer calculateHValue(Board board) {
		ArrayList<Cell> chests = board.getChests();
		for (Cell chest : chests) {
			if (chest.getCellType() != CellType.GOAL && board.isWallCornered(chest)) {
				return MAX_H;
			}
		}
		
		return manhattanDistances(board, chests);
	}
	
	private int manhattanDistances(Board board, ArrayList<Cell> chests) {
		int mDistance = 0;
		
		for (Cell goal : board.getGoals()) {
			if (goal.getBoardEntity() == BoardEntity.CHEST) {
				continue;
			}
			
			mDistance += getTotalMDistance(goal, chests);
		}
		
		return mDistance;
	}
	
	private int getTotalMDistance(Cell goal, ArrayList<Cell> chests) {
		int total = 0;
		for (Cell chest : chests) {
			if (chest.getCellType() == CellType.GOAL) {
				continue;
			}
			int x = Math.abs(chest.getX() - goal.getX());
			int y = Math.abs(chest.getY() - goal.getY());
			total += (x + y);
		}
		
		return total;
	}
}
