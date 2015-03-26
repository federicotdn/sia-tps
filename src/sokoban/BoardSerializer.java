package sokoban;

import java.io.BufferedReader;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStreamReader;

import sokoban.Cell.CellType;
import sokoban.exceptions.InvalidBoardException;

public class BoardSerializer {
	
	private static final char PLAYER = 'P';
	private static final char CHEST = 'C';
	private static final char EMPTY = 'E';
	private static final char WALL = 'W';
	private static final char GOAL = 'G';
	
	public static Board fromFile(String filename) {
		try {
			FileInputStream file = new FileInputStream(filename);
			BufferedReader br = new BufferedReader(new InputStreamReader(file));

			Board board = new Board();
			String line;
			int width = 0, i = 0;
			boolean hasLine = false;

			while ((line = br.readLine()) != null) {
				if (!hasLine) {
					width = line.length();
					hasLine = true;
				} else {
					if (line.length() != width) {
						br.close();
						throw new InvalidBoardException();
					}
				}

				for (char ch : line.toCharArray()) {
					int j = 0;
					addToBoard(board, i, j, ch);
				}

				i++;
			}

			if (!hasLine) {
				br.close();
				throw new InvalidBoardException();
			}

			br.close();
			return board;

		} catch (IOException e) {
			return null;
		}
	}

	private static void addToBoard(Board board, int i, int j, char ch) {
		switch (ch) {
		case EMPTY:
			board.addCell(j, i, CellType.EMPTY, null);
			break;
		case WALL:
			board.addCell(j, i, CellType.WALL, null);
			break;
		case GOAL:
			board.addCell(j, i, CellType.GOAL, null);
			break;
		case PLAYER:
			board.addCell(j, i, CellType.EMPTY, BoardEntity.PLAYER);
			break;
		case CHEST:
			board.addCell(j, i, CellType.EMPTY, BoardEntity.CHEST);
			break;
		default:
			throw new InvalidBoardException();
		}
	}

	public static void printBoard(Board board) {
		
	}
}
