package sokoban;

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
	
	public BoardEntity getBoardEntity() {
		return entity;
	}
	
	public int getX() {
		return x;
	}
	
	public int getY() {
		return y;
	}
}