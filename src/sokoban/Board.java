package sokoban;

import java.awt.Point;
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
	
	public Cell getPlayerCell(){
		return playerCell;
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
	
	public void movePlayer(BoardPoint move) {
		Cell nextCell = getCell(playerCell.getX() + move.getX(), playerCell.getY() + move.getY());
		Cell secondCell = getCell(nextCell.getX() + move.getX(), nextCell.getY() + move.getY());
		secondCell.setBoardEntity(nextCell.getBoardEntity());
		nextCell.setBoardEntity(playerCell.getBoardEntity());
		playerCell.setBoardEntity(null);
		playerCell = nextCell;
	}
	
	public Cell getCell(int x, int y){
		return rows.get(y)[x];
	}
}
