package sokoban;

import sokoban.exceptions.InvalidBoardException;

public class Cell {
	public enum CellType {
		WALL, EMPTY, GOAL;
	}

	private CellType cellType;
	private BoardEntity entity;
	private int x, y;

	public Cell(int x, int y, CellType cellType, BoardEntity entity) {
		this.x = x;
		this.y = y;
		this.cellType = cellType;
		this.entity = entity;
	}

	public CellType getCellType() {
		return cellType;
	}

	public void setBoardEntity(BoardEntity entity) {
		if (cellType == CellType.WALL) {
			throw new InvalidBoardException("Wall cell cannot hold entities.");
		}
		this.entity = entity;
	}

	public BoardEntity getBoardEntity() {
		return entity;
	}

	public boolean isWall() {
		return cellType == CellType.WALL;
	}

	public int getX() {
		return x;
	}

	public int getY() {
		return y;
	}

	public boolean hasChest() {
		return entity == BoardEntity.CHEST;
	}
}