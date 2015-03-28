package sokoban;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

public class SokobanRule implements GPSRule {
	public enum Direction {
		UP, DOWN, LEFT, RIGHT;
	}

	private Direction direction;
	private BoardPoint move;
	
	public SokobanRule(Direction direction, int x, int y) {
		this.direction = direction;
		this.move = new BoardPoint(x, y);
	}
	
	@Override
	public Integer getCost() {
		return 1;
	}

	@Override
	public String getName() {
		return direction.toString();
	}
	
	public BoardPoint getMove(){
		return move;
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
