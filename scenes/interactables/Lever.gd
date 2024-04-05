extends Node2D

@export var activated: bool = false;

enum STATE {
	OFF,
	HOVER,
	ON
}

func switch_state(id: STATE):
	if (id == STATE.OFF):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(3, 2))
	elif (id == STATE.HOVER):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(3, 3))
	elif (id == STATE.ON):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(4, 2))

func activate():
	activated = true;

# Called when the node enters the scene tree for the first time.
func _ready():
	if (activated):
		switch_state(STATE.ON)
	else:
		switch_state(STATE.OFF)

func _on_active_box_body_entered(body):
	if (!activated): switch_state(STATE.HOVER)

func _on_active_box_body_exited(body):
	if (!activated): switch_state(STATE.OFF)
