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

			Board board = null;
			String line;
			int width = 0, i = 0;

			while ((line = br.readLine()) != null) {
				if (board == null) {
					width = line.length();
					board = new Board(width);
				} else {
					if (line.length() != width) {
						br.close();
						throw new InvalidBoardException("Invalid line length.");
					}
				}

				board.addRow();
				
				int j = 0;
				for (char ch : line.toCharArray()) {
					addToBoard(board, i, j++, ch);
				}

				i++;
			}
			br.close();
			
			if (board == null || !board.hasPlayer()) {
				throw new InvalidBoardException("Empty file, or no player found.");
			}

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
			throw new InvalidBoardException("Invalid char found.");
		}
	}

	public static void printBoard(Board board) {
		for (Cell[] row : board.getRows()) {
			for (Cell cell : row) {
				BoardEntity ent = cell.getBoardEntity();
				
				if (ent != null) {
					switch (ent) {
					case CHEST:
						System.out.print(CHEST);
						break;
					case PLAYER:
						System.out.print(PLAYER);
						break;
					}						
				} else {
					switch (cell.getCellType()) {
					case WALL:
						System.out.print(WALL);
						break;
					case EMPTY:
						System.out.print(EMPTY);
						break;
					case GOAL:
						System.out.print(GOAL);
						break;
					}
				}
			}
			
			System.out.println();
		}
	}
}
