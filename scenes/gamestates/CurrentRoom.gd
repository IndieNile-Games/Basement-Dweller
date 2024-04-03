extends Node2D

@export var player: Player;

@onready var room_spawn: Marker2D = get_child(0).get_child(1).get_child(0)

func init_player_pos():
	player.position = room_spawn.position;

# Called when the node enters the scene tree for the first time.
func _ready():
	init_player_pos()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
