package sokoban;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

public class SokobanRule implements GPSRule {
	private static final int MOVE_COST = 1;

	public enum Direction {
		UP(0, -1), DOWN(0, 1), LEFT(-1, 0), RIGHT(1, 0);

		private int x, y;
		public static final Direction[][] corners = {
				{ Direction.UP, Direction.LEFT },
				{ Direction.UP, Direction.RIGHT },
				{ Direction.DOWN, Direction.LEFT },
				{ Direction.DOWN, Direction.RIGHT } };

		private Direction(int x, int y) {
			this.x = x;
			this.y = y;
		}

		public Cell getAdjacentCell(Board board, Cell cell) {
			int cell_x = cell.getX();
			int cell_y = cell.getY();

			return board.getCell(cell_x + x, cell_y + y);
		}
	}

	private Direction direction;

	public SokobanRule(Direction direction) {
		this.direction = direction;
	}

	@Override
	public Integer getCost() {
		return MOVE_COST;
	}

	@Override
	public String getName() {
		return direction.toString();
	}

	public Direction getDirection() {
		return direction;
	}

	@Override
	public GPSState evalRule(GPSState state) throws NotAppliableException {
		/*
		 * Downcast para no tener que cambiar la interfaz de la catedra.
		 */
		SokobanState st = (SokobanState) state;
		return st.evalRule(this);
	}
}
