package sokoban;

import gps.api.GPSRule;
import gps.api.GPSState;
import gps.exception.NotAppliableException;

public class SokobanRule implements GPSRule {

	private String name;
	
	public SokobanRule(String name) {
		this.name = name;
	}
	
	@Override
	public Integer getCost() {
		return 1;
	}

	@Override
	public String getName() {
		return name;
	}

	@Override
	public GPSState evalRule(GPSState state) throws NotAppliableException {
		// TODO Auto-generated method stub
		return null;
	}

}
