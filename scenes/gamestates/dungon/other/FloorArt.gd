extends Sprite2D
class_name FloorArt

@export var link_code: int = -1
@export var switchable_frames: Array[int] = [frame]

var current_index: int = 0;

func _ready():
	frame = switchable_frames[current_index]

func _change_state():
	current_index = current_index + 1;
	if (current_index >= switchable_frames.size()):
		current_index = 0;
	frame = switchable_frames[current_index]
