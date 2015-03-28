package sokoban;

import java.awt.Point;

import sokoban.SokobanRule.Direction;

import gps.api.GPSState;

public class SokobanState implements GPSState {

	private Board board;
	
	public SokobanState(Board board) {
		this.board = board;
	}

	public SokobanState evalRule(SokobanRule rule) {
		if (canEvalRule(rule)){
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
	
	public boolean canEvalRule(SokobanRule rule) {
		Cell player = board.getPlayerCell();
		
		Direction direction = rule.getDirection();
		
		Cell movingCell = direction.getAdjacentCell(board, player); //metodo para conseguir el adjacent usando la direccion
		// ya no deberia ser necesario usar Point
		
		/*
		 * Esto no necesariamente va a funcionar porque si el jugador esta contra el borde ya 
		 * no quedan mas celdas para buscar al costado.
		 * 
		 * Primero me fijaria si esta contra una pared y si es asi ya salgo.
		 * 
		 * Si no esta contra una pared si o si va a haber una distancia de dos bloques hasta el
		 * borde del mapa.
		 */
		//Cell secondCell = direction.getAdjacentCell(board, movingCell);
		
		//Cell movingCell = board.getCell(player.getX() + move.getX(), player.getY() + move.getY());
		//Cell secondCell = board.getCell(movingCell.getX() + move.getX(), movingCell.getY() + move.getY());

		
		
		/*		switch (movingCell.getCellType()){
			case WALL: return false;
			default: switch (secondCell.getCellType()){
				case WALL: return false;
				default: switch (secondCell.getBoardEntity()){
					case CHEST: return false;
					default: break;
				}
			}
		}*/
		return true;
	}
}
