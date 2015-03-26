package sokoban;

public class Cell {
	public enum CellType {
		WALL, EMPTY, GOAL;
	}
	
	private CellType cellType;
	private BoardEntity entity;
	
	public Cell(CellType cellType, BoardEntity entity) {
		this.cellType = cellType;
		this.entity = entity;
	}
}