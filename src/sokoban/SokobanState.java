package sokoban;

import gps.api.GPSState;

public class SokobanState implements GPSState {

	private Board board;
	
	public SokobanState() {
		board = new Board();
	}
	
	@Override
	public boolean compare(GPSState state) {
		// TODO Auto-generated method stub
		return false;
	}

}
