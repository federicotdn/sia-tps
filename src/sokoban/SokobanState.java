package sokoban;

import sokoban.SokobanRule.Direction;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

public class SokobanState implements GPSState {

	private Board board;

	public SokobanState(Board board) {
		this.board = board;
	}

	public SokobanState evalRule(SokobanRule rule) throws NotAppliableException {
		if (canEvalRule(rule)) {
			SokobanState st = new SokobanState(board);
			st.getBoard().movePlayer(rule.getDirection());
			return st;
		}
		throw new NotAppliableException();
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
		return board.equalsBoard(st.getBoard());
	}

	public boolean canEvalRule(SokobanRule rule) {
		Cell player = board.getPlayerCell();
		Direction direction = rule.getDirection();
		Cell movingCell = direction.getAdjacentCell(board, player);

		if (movingCell.isWall()) {
			return false;
		}

		if (movingCell.hasChest()) {
			return checkSecondMove(direction, movingCell);
		}
		return true;
	}

	public boolean checkSecondMove(Direction direction, Cell cell) {
		Cell adjacentCell = direction.getAdjacentCell(board, cell);
		return !(adjacentCell.isWall() || adjacentCell.hasChest());
	}
}
