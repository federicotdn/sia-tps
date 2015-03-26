package sokoban;

public class Board {
	private static final int WIDTH = 20;
	private static final int HEIGHT = 16;
	
	private Cell[][] cells;
	
	public Board() {
		cells = new Cell[HEIGHT][];
		for (int i = 0; i < HEIGHT; i++) {
			cells[i] = new Cell[WIDTH];
		}
	}
	
}
