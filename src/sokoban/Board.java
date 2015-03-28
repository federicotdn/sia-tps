package sokoban;

import java.util.ArrayList;

import sokoban.Cell.CellType;
import sokoban.exceptions.InvalidBoardException;

public class Board {
	private ArrayList<Cell[]> rows;
	private Cell playerCell;
	private int width;
	
	public Board(int width) {
		this.width = width;
		playerCell = null;
		rows = new ArrayList<Cell[]>();
	}
	
	public void addRow() {
		rows.add(new Cell[width]);
	}
	
	public ArrayList<Cell[]> getRows() {
		return rows;
	}
	
	public void addCell(int x, int y, CellType type, BoardEntity entity) {
		Cell[] row = rows.get(y);
		row[x] = new Cell(x, y, type, entity);
		
		if (entity == BoardEntity.PLAYER) {
			if (playerCell != null) {
				throw new InvalidBoardException("Duplicate player found.");
			}
			playerCell = row[x];
		}
	}
	
	public boolean hasPlayer() {
		return playerCell != null;
	}
}
