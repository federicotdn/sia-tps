package sokoban.heuristics;

import java.util.ArrayList;

import sokoban.Board;
import sokoban.Cell;
import sokoban.Cell.CellType;

public class DeadlockHeuristic extends DistanceOnlyHeuristic {

	private static final Integer MAX_H = Integer.MAX_VALUE;
	
	@Override
	protected Integer calculateHValue(Board board) {
		/*
		 * Mejorar: super.calculateHValue() pide los chests de nuevo.
		 */
		ArrayList<Cell> chests = board.getChests();
		for (Cell chest : chests) {
			if (chest.getCellType() != CellType.GOAL && board.isCornered(chest)) {
				return MAX_H;
			}
		}
		
		return super.calculateHValue(board);
	}
}
