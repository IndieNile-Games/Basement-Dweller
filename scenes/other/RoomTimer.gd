extends Node2D
class_name RoomTimer

var active: bool = false;
var time: float = 0.0;

func reset():
	time = 0.0

func _generate_num_str(num: int, min_size: int = 2, max_size: int = -1):
	var final_str: String = str(num);
	
	if (final_str.length() < min_size && min_size != -1):
		final_str = "0".repeat(min_size - final_str.length()) + final_str
	if (final_str.length() > max_size && max_size != -1):
		final_str = final_str.left(max_size - final_str.length())
	
	return final_str;

func get_time_string() -> String:
	var ms: int = int(time * 1000);
	var s: int = floor(ms / 1000);
	var m: int = floor(s / 60);
	var h: int = floor(m / 60)
	
	var final: String = "";
	
	if (h > 0): final = _generate_num_str(h, 2) + ":"
	if (m > 0): final = final + _generate_num_str(m % 60, 2, 2) + ":"
	if (s > 0): 
		final = final + _generate_num_str(s % 60, 2, 2) + "."
	else:
		final = final + "00."
	final = final + _generate_num_str(ms % 1000, 2, 2)
	
	return final;

func start():
	reset();
	active = true;

func stop():
	active = false;

func _process(delta):
	if (active): time = time + delta;
