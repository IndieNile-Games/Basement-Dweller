extends Node2D

@export var TargetNode: Node2D;
@export var BoundingTarget: Node2D;
@export var lerp_speed: float = 0.1;
@export var camera_tile_border: float = 1.5;

var bounding_rect: Rect2;

@onready var CameraNode: Camera2D = get_child(0).get_child(0)
@onready var BoundingTilemap: TileMap = BoundingTarget.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(TargetNode.position);
	pass # Replace with function body.

func update_bounds():
	
	CameraNode.limit_left = (BoundingTilemap.get_used_rect() .position.x - camera_tile_border) * BoundingTilemap.tile_set.tile_size[0]
	CameraNode.limit_top = (BoundingTilemap.get_used_rect().position.y - camera_tile_border) * BoundingTilemap.tile_set.tile_size[1]
	CameraNode.limit_right = (BoundingTilemap.get_used_rect().end.x + camera_tile_border) * BoundingTilemap.tile_set.tile_size[0]
	CameraNode.limit_bottom = (BoundingTilemap.get_used_rect().end.y + camera_tile_border) * BoundingTilemap.tile_set.tile_size[1]
	
	pass

func lerp_to_target():
	set_position(lerp(position, TargetNode.position, lerp_speed));

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	update_bounds()
	lerp_to_target()
	
	pass
