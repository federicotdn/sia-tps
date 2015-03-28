package sokoban.exceptions;

public class InvalidBoardException extends RuntimeException {
	public InvalidBoardException(String msg) {
		super(msg);
	}
}
