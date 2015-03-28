package sokoban;

public class Start {
	public static void main(String[] args) {
		
		Board b = BoardSerializer.fromFile("/home/fede/Workspace/sia-tp1/maps/map1.txt");
		BoardSerializer.printBoard(b);
		
	}
}
