package sokoban;

import sokoban.SokobanRule.Direction;
import sokoban.heuristics.DistanceOnlyHeuristic;
import gps.SearchStrategy;

public class Start {
	public static void main(String[] args) {
		
		Board b = BoardSerializer.fromFile("/home/fede/Workspace/sia-tp1/maps/map1.txt");
		BoardSerializer.printBoard(b);
		System.out.println("Begin:");
		
		SokobanEngine startThe = new SokobanEngine();
		DistanceOnlyHeuristic h = new DistanceOnlyHeuristic(false);
		SokobanProblem problem = new SokobanProblem(b, h);
		
		startThe.engine(problem, SearchStrategy.Greedy);
	}
}
