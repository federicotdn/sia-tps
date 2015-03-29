package sokoban;

import java.util.ArrayList;
import sokoban.Cell.CellType;
import sokoban.SokobanRule.Direction;
import sokoban.exceptions.InvalidBoardException;

public class Board {
	private ArrayList<Cell[]> rows;
	private Cell playerCell;
	private int width;
	private int chests = 0, goals = 0;

	public Board(int width) {
		this.width = width;
		playerCell = null;
		rows = new ArrayList<Cell[]>();
	}

	public Cell getPlayerCell() {
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

		if (type == CellType.GOAL) {
			goals++;
		}
		
		if (entity == BoardEntity.CHEST) {
			chests++;
		}
		
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
	
	public int getWidth() {
		return width;
	}
	
	public Board clone() {
		Board board = new Board(width);
		for (int i = 0; i < rows.size(); i++) {
			board.addRow();
			
			for (int j = 0; j < width; j++) {
				Cell cell = rows.get(i)[j];
				board.addCell(j, i, cell.getCellType(), cell.getBoardEntity());
			}
		}
		
		return board;
	}
	
	public boolean equalsBoard(Board board) {
		ArrayList<Cell[]> otherRows = board.getRows();
		if (otherRows.size() != rows.size() || width != board.getWidth()) {
			return false;
		}
		
		for (int i = 0; i < rows.size(); i++) {
			Cell[] row = rows.get(i);
			Cell[] otherRow = otherRows.get(i);
			
			for (int j = 0; j < width; j++) {
				Cell cell = row[j];
				Cell otherCell = otherRow[j];
				
				if (cell.getCellType() != otherCell.getCellType() || 
						cell.getBoardEntity() != otherCell.getBoardEntity()) {
					return false;
				}
			}
		}
		
		return true;
	}

	public void movePlayer(Direction direction) {
		Cell nextCell = direction.getAdjacentCell(this, playerCell);
		if (nextCell.hasChest()) {
			Cell secondCell = direction.getAdjacentCell(this, nextCell);
			nextCell.setBoardEntity(null);
			secondCell.setBoardEntity(BoardEntity.CHEST);
		}
		
		playerCell.setBoardEntity(null);
		nextCell.setBoardEntity(BoardEntity.PLAYER);
		playerCell = nextCell;
	}

	public Cell getCell(int x, int y) {
		return rows.get(y)[x];
	}
	
	public boolean isCompleted() {
		for (Cell[] row : rows) {
			for (Cell cell : row) {
				if (cell.getCellType() == CellType.GOAL && cell.getBoardEntity() != BoardEntity.CHEST) {
					return false;
				}
			}
		}
		
		return true;
	}
	
	public void validateChestCount() {
		if (chests < goals) {
			throw new InvalidBoardException("Chests count must be higher or equal than goals count.");
		}
	}
	
	public ArrayList<Cell> getBoxes() {
		ArrayList<Cell> boxes = new ArrayList<Cell>(); 
		for (Cell[] row : rows){
			for (Cell cell : row){
				if(cell.getBoardEntity() == BoardEntity.CHEST){
					boxes.add(cell);
				}
			}
		}
		return boxes;
	}
	
	public ArrayList<Cell> getGoals() {
		ArrayList<Cell> goals = new ArrayList<Cell>(); 
		for (Cell[] row : rows){
			for (Cell cell : row){
				if(cell.getCellType() == CellType.GOAL){
					goals.add(cell);
				}
			}
		}
		return goals;
	}
}
