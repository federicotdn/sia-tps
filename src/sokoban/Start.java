package sokoban;

import gps.SearchStrategy;

public class Start {
	public static void main(String[] args) {
		
		Board b = BoardSerializer.fromFile("/home/fede/Workspace/sia-tp1/maps/map1.txt");
		BoardSerializer.printBoard(b);
		System.out.println("Begin:");
		
		SokobanEngine engine = new SokobanEngine();
		SokobanProblem problem = new SokobanProblem(b, null); // agregar heuristica mas tarde
		
		engine.engine(problem, SearchStrategy.DFS);
	}
}
