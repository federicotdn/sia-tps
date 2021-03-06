package sokoban;

import java.util.ArrayList;
import sokoban.Cell.CellType;
import sokoban.SokobanRule.Direction;
import sokoban.exceptions.InvalidBoardException;

public class Board {
	private ArrayList<Cell[]> rows;
	private Cell playerCell;
	private ArrayList<Cell> goals;
	private int width;
	private int chestCount = 0, goalCount = 0;
	private Integer hValue = null;

	public Board(int width) {
		this.width = width;
		playerCell = null;
		rows = new ArrayList<Cell[]>();
		goals = new ArrayList<Cell>();
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
			goalCount++;
			goals.add(row[x]);
		}
		
		if (entity == BoardEntity.CHEST) {
			chestCount++;
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
		if (chestCount != goalCount) {
			throw new InvalidBoardException("Chests count must be equal than goals count.");
		}
	}
	
	public ArrayList<Cell> getChests() {
		ArrayList<Cell> chests = new ArrayList<Cell>(); 
		for (Cell[] row : rows){
			for (Cell cell : row){
				if(cell.getBoardEntity() == BoardEntity.CHEST){
					chests.add(cell);
				}
			}
		}
		
		return chests;
	}
	
	public boolean isCornered(Cell cell) {
		for (Direction[] corner : Direction.corners) {
			Cell side1 = corner[0].getAdjacentCell(this, cell);
			Cell side2 = corner[1].getAdjacentCell(this, cell);
			if ((side1.isWall() || side1.hasChest()) && (side2.isWall() || side2.hasChest())) {
				return true;
			}
		}
		return false;
	}
	
	public boolean isWallCornered(Cell cell) {
		for (Direction[] corner : Direction.corners) {
			Cell side1 = corner[0].getAdjacentCell(this, cell);
			Cell side2 = corner[1].getAdjacentCell(this, cell);
			if (side1.isWall() && side2.isWall()) {
				return true;
			}
		}
		return false;	
	}
	
	public Integer getHValue() {
		return hValue;
	}
	
	public void setHValue(Integer hValue) {
		this.hValue = hValue;
	}
	
	public ArrayList<Cell> getGoals() {
		return goals;
	}
}
