package sokoban;

import java.util.Scanner;
import sokoban.heuristics.DeadlockHeuristic;
import sokoban.heuristics.DistanceOnlyHeuristic;
import sokoban.heuristics.ManhattanHeuristic;
import sokoban.heuristics.SokobanHeuristic;
import gps.SearchStrategy;

public class Start {
	public static void main(String[] args) {
		Scanner userInput = new Scanner(System.in);
		SokobanEngine engine = new SokobanEngine();
		SokobanProblem problem;
		SokobanHeuristic h;
		
		System.out.println("Sokoban - SIA");
		System.out.println("Elegir un numero de mapa:");
		System.out.println("(Opciones: 1, 2, 3, 4, 5, 6)");
		
		int n = userInput.nextInt();
		if (n < 1 || n > 6) {
			System.out.println("Mapa invalido.");
			userInput.close();
			return;
		}
		
		Board board = BoardSerializer.fromFile("maps/map" + n +".txt");
		
		System.out.println("Elegir un método:");
		System.out.println("(Opciones: DFS, BFS, Iterative, Greedy, A*)");
		String method = userInput.next();
		
		switch (method) {
		case "DFS":
			System.out.println("Utilizando DFS.");
			problem = new SokobanProblem(board, null);
			engine.start(problem, SearchStrategy.DFS);
			break;
		case "BFS":
			System.out.println("Utilizando BFS.");
			problem = new SokobanProblem(board, null);
			engine.start(problem, SearchStrategy.BFS);
			break;
		case "Iterative":
			System.out.println("Utilizando Iterative.");
			problem = new SokobanProblem(board, null);
			engine.startIterative(problem);
			break;
		case "Greedy":
			h = getHeuristicChoice(userInput);
			if (h == null) {
				return;
			}
			System.out.println("Utilizando Greedy.");
			problem = new SokobanProblem(board, h);
			engine.start(problem, SearchStrategy.Greedy);
			break;
		case "A*":
			h = getHeuristicChoice(userInput);
			if (h == null) {
				return;
			}
			System.out.println("Utilizando A*.");
			problem = new SokobanProblem(board, h);
			engine.start(problem, SearchStrategy.AStar);
			break;
		default:
			System.out.println("Opcion invalida.");
			userInput.close();
			return;
		}

		userInput.close();
	}
	
	private static SokobanHeuristic getHeuristicChoice(Scanner userInput) {
		System.out.println("Elegir una heuristica:");
		System.out.println("(Opciones: 1a (DistanceOnly), 1b (DistanceOnly con Deadlock), 2 (Manhattan))");
		String choice = userInput.next();
		switch (choice) {
		case "1a":
			return new DistanceOnlyHeuristic();
		case "1b":
			return new DeadlockHeuristic();
		case "2":
			return new ManhattanHeuristic();
		default:
			System.out.println("Opcion invalida.");
			return null;
		}
	}
}
