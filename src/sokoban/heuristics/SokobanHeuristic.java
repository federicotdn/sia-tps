package sokoban.heuristics;

import sokoban.Board;

public abstract class SokobanHeuristic {
	
	public Integer getHValue(Board board) {
		Integer hValue = board.getHValue();
		if (hValue == null) {
			hValue = calculateHValue(board);
			board.setHValue(hValue);
		}
		
		return hValue;
	}
	
	protected abstract Integer calculateHValue(Board board);
}
