package sokoban.exceptions;

@SuppressWarnings("serial")
public class InvalidBoardException extends RuntimeException {
	public InvalidBoardException(String msg) {
		super(msg);
	}
}
