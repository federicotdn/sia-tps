package sokoban.heuristics;

import sokoban.Board;

public interface SokobanHeuristic {
	Integer getHValue(Board board);
}
