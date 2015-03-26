package sokoban;

public class Test {

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		SokobanRule.Direction d = SokobanRule.Direction.LEFT;
		System.out.println(d.toString());
		BoardSerializer.fromFile("/home/fede/Workspace/maps/map1.txt");
	}

}
