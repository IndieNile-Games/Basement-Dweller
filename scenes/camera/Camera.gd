extends Node2D

@export var TargetNode: Node2D;
@export var BoundingNode: Node2D;
@export var lerp_speed: float = 0.1;

# Called when the node enters the scene tree for the first time.
func _ready():
	set_position(TargetNode.position);
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_position(lerp(position, TargetNode.position, lerp_speed));
	pass
