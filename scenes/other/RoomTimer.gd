extends Node2D
class_name RoomTimer

var active: bool = false;
var time: float = 0.0;

func reset():
	time = 0.0

func start():
	reset();
	active = true;

func stop():
	active = false;

func _process(delta):
	if (active): time = time + delta;
