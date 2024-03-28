extends Node2D

@export var TargetNode: Node2D;
@export var BoundingNode: Node2D;
@export var lerp_speed: float = 0.1;
@export var bound_limit: Vector2 = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(TargetNode.position);
	pass # Replace with function body.

func update_bounds():
	# get_parent().get_node("SmallL").get_used_rect()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	
	update_bounds()
	
	set_position(lerp(position, TargetNode.position, lerp_speed));
	pass
