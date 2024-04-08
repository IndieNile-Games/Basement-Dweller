extends Node2D
class_name CustomCamera

@export var TargetNode: Node2D;
@export var BoundingTarget: Node2D;
@export var lerp_speed: float = 0.1;
@export var camera_tile_border: float = 1.5;

var bounding_rect: Rect2;

@onready var CameraNode: Camera2D = get_child(0).get_child(0)
@onready var BoundingTilemap: TileMap = BoundingTarget.get_child(0)

var temp_disable: bool = false;

const INF_BOUNDS: Rect2i = Rect2(-10000000, -10000000, 20000000, 20000000);

# Called when the node enters the scene tree for the first time.
func _ready():
	print(get_viewport_rect().size)
	
	set_position(TargetNode.position);
	pass # Replace with function body.

func update_bounds():
	
	bounding_rect.position.x = (BoundingTilemap.get_used_rect() .position.x - camera_tile_border) * BoundingTilemap.tile_set.tile_size[0]
	bounding_rect.position.y = (BoundingTilemap.get_used_rect().position.y - camera_tile_border) * BoundingTilemap.tile_set.tile_size[1]
	bounding_rect.end.x = (BoundingTilemap.get_used_rect().end.x + camera_tile_border) * BoundingTilemap.tile_set.tile_size[0]
	bounding_rect.end.y = (BoundingTilemap.get_used_rect().end.y + camera_tile_border) * BoundingTilemap.tile_set.tile_size[1]
	
	# if (get_viewport_rect().size.x > bounding_rect.size.x):
	# 	bounding_rect.position.x = ((bounding_rect.position.x+(bounding_rect.size.x/2)) - (get_viewport_rect().size.x/2))/2
	# 	bounding_rect.end.x = ((bounding_rect.position.x + get_viewport_rect().size.x)/3)-2
	# if (get_viewport_rect().size.y > bounding_rect.size.y):
	# 	bounding_rect.position.y = ((bounding_rect.position.y+(bounding_rect.size.y/2)) - (get_viewport_rect().size.y/2))/4
	# 	bounding_rect.end.y = ((bounding_rect.position.y + get_viewport_rect().size.y)/3)-2
	
	if (!temp_disable): set_bounds(bounding_rect)
	
	pass

func lerp_to_target():
	set_position(lerp(position, TargetNode.position, lerp_speed));

func set_bounds(rect: Rect2i):
	CameraNode.limit_left = rect.position.x
	CameraNode.limit_top = rect.position.y
	CameraNode.limit_right = rect.end.x
	CameraNode.limit_bottom = rect.end.y

func toggle_disable(disable: bool):
	temp_disable = disable;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	update_bounds()
	lerp_to_target()
	
	pass
