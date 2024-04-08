extends Node2D

@export var opening_scene: String;
@export var player: Node2D;

var room: PackedScene;
var room_scene;
var room_spawn: Marker2D;

func init_player_pos():
	player.position = room_spawn.position;

func next_room():
	init()

func set_room(path: String):
	room = load(path)
	room_scene = room.instantiate()
	room_scene.y_sort_enabled = true;
	add_child(room_scene)
	get_parent().get_node("RoomTimer").reset()
	get_parent().get_node("Music").get_node("Main").play()
	get_parent().get_node("Camera").BoundingTarget = room_scene;
	room_spawn = room_scene.get_node("Tile Map").get_node("POI").get_node("Spawn")
	player.room_cleared.connect(next_room)

func init():
	player.reset();
	init_player_pos()
	get_parent().get_node("RoomTimer").start()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	set_room(opening_scene)
	init()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
