package sokoban;

import gps.api.GPSState;

public class SokobanState implements GPSState<SokobanState> {

	private Board board;
	
	public SokobanState() {
		board = new Board();
	}
	
	@Override
	public boolean compare(SokobanState state) {
		return board.equals(state.getBoard());
	}

	public SokobanState evalRule(SokobanRule rule) {
		return null;
	}
	
	private Board getBoard() {
		return board;
	}
}
