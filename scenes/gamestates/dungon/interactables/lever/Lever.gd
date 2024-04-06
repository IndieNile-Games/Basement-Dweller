extends Node2D

@export var activated: bool = false;
@export var link_code: int = -1;

@onready var actionables_box: Node2D = get_parent().get_parent().get_node("Props")

enum STATE {
	OFF,
	HOVER,
	ON
}

var body_nearby: bool = false;

signal lever_toggled();

func process_sprites():
	if (activated):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(4, 2))
	elif (body_nearby):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(3, 3))
	else:
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(3, 2))

func toggle(active: bool):
	if (activated != active):
		activated = active;
		emit_signal("lever_toggled");

# Called when the node enters the scene tree for the first time.
func _ready():
	if (link_code != -1):
		for actionable in actionables_box.get_children():
			if (link_code == actionable.link_code):
				connect("lever_toggled", actionable._change_state)

func _process(_delta):
	process_sprites();

func _on_active_box_body_entered(body):
	body_nearby = true;

func _on_active_box_body_exited(body):
	body_nearby = false;
