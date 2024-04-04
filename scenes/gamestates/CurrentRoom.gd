extends Node2D

@export var player: Node2D;

var room: PackedScene;
var room_scene;
var room_spawn: Marker2D;

func init_player_pos():
	player.position = room_spawn.position;

func set_room(path: String):
	room = load(path)
	room_scene = room.instantiate()
	room_scene.y_sort_enabled = true;
	add_child(room_scene)
	get_parent().get_child(1).BoundingTarget = room_scene;
	room_spawn = room_scene.get_child(1).get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_room("res://scenes/rooms/Tutorial Room.tscn")
	
	init_player_pos()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
