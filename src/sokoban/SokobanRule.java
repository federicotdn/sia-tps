package sokoban;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

public class SokobanRule implements GPSRule {
	public enum Direction {
		UP, DOWN, LEFT, RIGHT;
	}

	private Direction direction;
	
	public SokobanRule(Direction direction) {
		this.direction = direction;
	}
	
	@Override
	public Integer getCost() {
		return 1;
	}

	@Override
	public String getName() {
		return direction.toString();
	}

	@Override
	public GPSState evalRule(GPSState state) throws NotAppliableException {
		/*
		 * Downcast para no tener que cambiar la interfaz de la catedra.
		 */
		SokobanState st = (SokobanState) state;
		
		return null;
	}
}
