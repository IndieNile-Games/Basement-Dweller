extends Node2D
class_name AllLink

@export var link_code: int = -1;
@export var emitting_link_code: int = -1;
@export var hits_until_emit: int = 1;

@onready var actionables_box: Node2D = get_parent()

var hits = 0;

signal emit_toggle();

# Called when the node enters the scene tree for the first time.
func _ready():
	if (emitting_link_code != -1):
		for actionable in actionables_box.get_children():
			if (emitting_link_code == actionable.link_code && self != actionable):
				connect("lever_toggled", actionable._change_state)

func _state_change():
	hits += 1;
	if (hits >= hits_until_emit):
		emit_signal("emit_toggle")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
