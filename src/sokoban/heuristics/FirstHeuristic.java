package sokoban.heuristics;

import java.util.ArrayList;

import sokoban.Board;
import sokoban.Cell;

public class FirstHeuristic implements SokobanHeuristic {

	@Override
	public Integer getHValue(Board board) {
		ArrayList<Cell> boxes = board.getBoxes();
		ArrayList<Cell> goals = board.getGoals();
		int manhattan = 0;
		for (int i = 0; i < boxes.size(); i++) {
			double distance = 1000;
			for (int j = 0; j < goals.size(); j++) {
				double aux = getMDistance(boxes.get(i), goals.get(j));
				if (aux < distance) {
					distance = aux;
				}
			}
			manhattan += distance;
		}
		return manhattan;
	}

	public double getMDistance(Cell box, Cell goal) {
		int x = Math.abs(box.getX() - goal.getX());
		int y = Math.abs(box.getY() - goal.getY());
		return Math.sqrt((Math.pow(x, 2) - Math.pow(y, 2)));
	}

}
