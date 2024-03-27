extends Node2D

@export var TargetNode: Node2D;

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var old_pos: Vector2 = get_position();
	
	
	set_position(TargetNode.get_position());
	pass
