extends CharacterBody2D

@export var speed: int = 50;

var is_chasing: bool = false;
var target: Node2D;

func _physics_process(_delta):
	if (is_chasing):
		velocity = (target.get_global_position() - position).normalized() * speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
		
	move_and_slide()

func _on_player_rect_body_entered(body):
	is_chasing = true;
	target = body
	$"Room Collision Box".set_deferred("disabled", true);
	
