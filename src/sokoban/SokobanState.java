package sokoban;

import gps.api.GPSState;

public class SokobanState implements GPSState {

	private Board board;
	
	public SokobanState(Board board) {
		this.board = board;
	}

	public SokobanState evalRule(SokobanRule rule) {
		return null;
	}
	
	private Board getBoard() {
		return board;
	}

	@Override
	public boolean compare(GPSState state) {
		/*
		 * Downcast para no tener que cambiar la interfaz de la catedra.
		 */
		SokobanState st = (SokobanState) state;
		
		return false;
	}
}
