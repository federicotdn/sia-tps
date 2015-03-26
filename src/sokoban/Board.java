package sokoban;

import sokoban.Cell.CellType;
import sokoban.exceptions.InvalidBoardException;

public class Board {
	private static final int WIDTH = 20;
	private static final int HEIGHT = 16;
	
	private Cell[][] cells;
	private Cell playerCell;
	
	public Board() {
		playerCell = null;
		
		cells = new Cell[HEIGHT][];
		for (int i = 0; i < HEIGHT; i++) {
			cells[i] = new Cell[WIDTH];
		}
	}
	
	public void addCell(int x, int y, CellType type, BoardEntity entity) {
		cells[y][x] = new Cell(x, y, type, entity);
		
		if (entity == BoardEntity.PLAYER) {
			if (playerCell != null) {
				throw new InvalidBoardException();
			}
			playerCell = cells[y][x];
		}
	}
	
}
