package gps;

import gps.api.GPSProblem;
import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

public abstract class GPSEngine {

	protected List<GPSNode> open = new LinkedList<GPSNode>();

	private List<GPSNode> closed = new ArrayList<GPSNode>();

	protected GPSProblem problem;

	// Use this variable in the addNode implementation
	protected SearchStrategy strategy;

	public void start(GPSProblem myProblem, SearchStrategy myStrategy) {

		problem = myProblem;
		strategy = myStrategy;

		GPSNode rootNode = new GPSNode(problem.getInitState(), 0);
		boolean finished = false;
		boolean failed = false;
		long explosionCounter = 0;
		long startTime = System.currentTimeMillis();
		open.add(rootNode);
		while (!failed && !finished) {
			if (open.size() <= 0) {
				failed = true;
			} else {
				GPSNode currentNode = open.get(0);
				closed.add(currentNode);
				open.remove(0);
				if (isGoal(currentNode)) {
					finished = true;
					System.out.println(currentNode.getSolution());
					System.out.println("Expanded nodes: " + explosionCounter);
				} else {
					explosionCounter++;
					explode(currentNode);
				}
			}
		}

		if (finished) {
			System.out.println("Nodos totales: " + (open.size() + closed.size()));
			System.out.println("Nodos frontera: " + (open.size()));
			System.out.println("Tiempo tardado: " + (System.currentTimeMillis() - startTime) + " milisegundos");
			System.out.println("OK! solution found!");
		} else if (failed) {
			System.err.println("FAILED! solution not found!");
		}
	}
	
	public void startIterative(GPSProblem problem) {
		this.problem = problem;
		this.strategy = SearchStrategy.DFS;
		
		long startTime = System.currentTimeMillis();
		boolean finished = false;
		long level = 1;
		int exploded = 0;
		
		while (!finished) {
			exploded = 0;
			open.clear();
			GPSNode initial = new GPSNode(problem.getInitState(), 0);
			open.add(initial);
			
			while (!open.isEmpty()) {
				GPSNode node = open.remove(0);
				if (node.getCost() < level) {
					exploded += explodeIterative(node);
				} else if (isGoal(node)) {
					System.out.println(node.getSolution());
					finished = true;
					break;
				}
			}
			
			level++;
		}
		
		if (finished) {
			System.out.println("Nodos totales: " + exploded);
			System.out.println("Nodos frontera: " + (open.size()));
			System.out.println("Nivel: " + level);
			System.out.println("Tiempo tardado: " + (System.currentTimeMillis() - startTime) + " milisegundos");
			System.out.println("OK! solution found!");
		}
	}
	
	private int explodeIterative(GPSNode node) {
		int counter = 0;
		
		for (GPSRule rule : problem.getRules()) {
			GPSState newState = null;
			try {
				newState = rule.evalRule(node.getState());
			} catch (NotAppliableException e) {
				// Do nothing
			}
			
			if (newState != null && !checkBranch(node, newState)) {
				GPSNode newNode = new GPSNode(newState, node.getCost() + rule.getCost());
				newNode.setParent(node);
				addNode(newNode);
				counter++;
			}
		}
		
		return counter;
	}

	private  boolean isGoal(GPSNode currentNode) {
		return currentNode.getState() != null
				&& problem.isGoalState(currentNode.getState());
	}

	private  boolean explode(GPSNode node) {
		if(problem.getRules() == null){
			System.err.println("No rules!");
			return false;
		}
		
		for (GPSRule rule : problem.getRules()) {
			GPSState newState = null;
			try {
				newState = rule.evalRule(node.getState());
			} catch (NotAppliableException e) {
				// Do nothing
			}
			if (newState != null
					&& !checkBranch(node, newState)
					&& !checkOpenAndClosed(node.getCost() + rule.getCost(),
							newState)) {
				GPSNode newNode = new GPSNode(newState, node.getCost()
						+ rule.getCost());
				newNode.setParent(node);
				addNode(newNode);
			}
		}
		return true;
	}

	private  boolean checkOpenAndClosed(Integer cost, GPSState state) {
		for (GPSNode openNode : open) {
			if (openNode.getState().compare(state) && openNode.getCost() <= cost) {
				return true;
			}
		}
		for (GPSNode closedNode : closed) {
			if (closedNode.getState().compare(state)
					&& closedNode.getCost() <= cost) {
				return true;
			}
		}
		return false;
	}

	private  boolean checkBranch(GPSNode parent, GPSState state) {
		if (parent == null) {
			return false;
		}
		return checkBranch(parent.getParent(), state)
				|| state.compare(parent.getState());
	}

	public abstract void addNode(GPSNode node);
}
