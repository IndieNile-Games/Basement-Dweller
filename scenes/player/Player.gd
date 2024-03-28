extends CharacterBody2D
class_name Player

@export var speed: int = 50
@export var sprint_mult: float = 2

var direction: Vector2 = Vector2.ZERO
var sprinting: bool = false

func _ready():
	$AnimationPlayer.play("idle_up")
	
	pass

func update_anim():
	$AnimationTree["parameters/conditions/is_idle"] = velocity == Vector2.ZERO
	$AnimationTree["parameters/conditions/is_moving"] = velocity != Vector2.ZERO
	
	$AnimationTree["parameters/conditions/is_sprinting"] = sprinting
	$AnimationTree["parameters/conditions/not_sprinting"] = !sprinting
	
	if (velocity != Vector2.ZERO):
		$AnimationTree["parameters/Idle/blend_position"] = direction
		$AnimationTree["parameters/Walk/blend_position"] = direction
		$AnimationTree["parameters/Sprint/blend_position"] = direction
	
	pass
func _process(delta):
	update_anim()

func update_movement():
	direction = Input.get_vector("ig_left", "ig_right", "ig_up", "ig_down").normalized()
	sprinting = Input.is_action_pressed("ig_sprint")
	
	if direction:
		if sprinting:
			velocity = direction * speed * sprint_mult
		else:
			velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()

func _physics_process(delta):
	update_movement()
	
	pass
