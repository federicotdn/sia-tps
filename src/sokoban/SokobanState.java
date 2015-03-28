package sokoban;

import java.awt.Point;

import gps.api.GPSState;

public class SokobanState implements GPSState {

	private Board board;
	
	public SokobanState(Board board) {
		this.board = board;
	}

	public SokobanState evalRule(SokobanRule rule) {
		if (canEvalRule(rule.getMove())){
			SokobanState st = new SokobanState(board);
			st.board.movePlayer(rule.getMove());
			return st;
		}
		return null;
	}
	
	public Board getBoard() {
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
	
	public boolean canEvalRule(BoardPoint move) {
		Cell player = board.getPlayerCell();
		Cell movingCell = board.getCell(player.getX() + move.getX(), player.getY() + move.getY());
		Cell secondCell = board.getCell(movingCell.getX() + move.getX(), movingCell.getY() + move.getY());
		switch (movingCell.getCellType()){
			case WALL: return false;
			default: switch (secondCell.getCellType()){
				case WALL: return false;
				default: switch (secondCell.getBoardEntity()){
					case CHEST: return false;
					default: break;
				}
			}
		}
		return true;
	}
}
