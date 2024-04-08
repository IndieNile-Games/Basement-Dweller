extends Node2D

@export var opening_scene: String;
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
	get_parent().get_node("Camera").BoundingTarget = room_scene;
	room_spawn = room_scene.get_node("Tile Map").get_node("POI").get_node("Spawn")

# Called when the node enters the scene tree for the first time.
func _ready():
	set_room(opening_scene)
	
	init_player_pos()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
