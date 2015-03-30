package sokoban;

import sokoban.SokobanRule.Direction;
import sokoban.heuristics.DeadlockHeuristic;
import sokoban.heuristics.DistanceOnlyHeuristic;
import sokoban.heuristics.ManhattanHeuristic;
import gps.SearchStrategy;

public class Start {
	public static void main(String[] args) {
		
		Board b = BoardSerializer.fromFile("maps/map5.txt");
		BoardSerializer.printBoard(b);
		System.out.println("Begin:");
		
		SokobanEngine startThe = new SokobanEngine();
		DistanceOnlyHeuristic h = new DeadlockHeuristic();
		ManhattanHeuristic man = new ManhattanHeuristic();
		SokobanProblem problem = new SokobanProblem(b, man);
		
		startThe.engine(problem, SearchStrategy.AStar);
	}
}
