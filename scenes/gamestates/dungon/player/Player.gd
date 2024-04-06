extends CharacterBody2D
class_name Player

@export var speed: int = 50
@export var sprint_mult: float = 2

var action_box_dist: int = 12;

var targeting_activatible: bool = false;
var targeted_activatible;

var direction: Vector2 = Vector2.ZERO

func _ready():
	$AnimationPlayer.play("idle_up")
	
	pass

func update_anim():
	$AnimationTree["parameters/conditions/is_idle"] = velocity == Vector2.ZERO
	$AnimationTree["parameters/conditions/is_moving"] = velocity != Vector2.ZERO
	
	$AnimationTree["parameters/conditions/is_sprinting"] = Input.is_action_pressed("ig_sprint")
	$AnimationTree["parameters/conditions/not_sprinting"] = !Input.is_action_pressed("ig_sprint")
	
	if (velocity != Vector2.ZERO):
		$AnimationTree["parameters/Idle/blend_position"] = direction
		$AnimationTree["parameters/Walk/blend_position"] = direction
		$AnimationTree["parameters/Sprint/blend_position"] = direction
	
	pass
func _process(_delta):
	update_anim()

func move_activatorbox(vector: Vector2):
	$"Activator Box/CollisionShape2D".position.x = 0;
	$"Activator Box/CollisionShape2D".position.y = -8;
	if (vector.x < -0.5): 
		$"Activator Box/CollisionShape2D".position.x = -action_box_dist;
		$"Activator Box/CollisionShape2D".position.y = -8;
	elif (vector.x > 0.5): 
		$"Activator Box/CollisionShape2D".position.x = action_box_dist;
		$"Activator Box/CollisionShape2D".position.y = -8;
	if (vector.y < -0.5): 
		$"Activator Box/CollisionShape2D".position.x = 0;
		$"Activator Box/CollisionShape2D".position.y = -action_box_dist - 8;
	elif (vector.y > 0.5): 
		$"Activator Box/CollisionShape2D".position.x = 0;
		$"Activator Box/CollisionShape2D".position.y = action_box_dist - 8;

func update_movement():
	direction = Input.get_vector("ig_left", "ig_right", "ig_up", "ig_down").normalized()
	
	if direction:
		if Input.is_action_pressed("ig_sprint"):
			velocity = direction * speed * sprint_mult
		else:
			velocity = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.y = move_toward(velocity.y, 0, speed)

	# move_activatorbox(direction)

	if (Input.is_action_just_pressed("ig_activate") && targeting_activatible):
		targeted_activatible.toggle(true)

	move_and_slide()

func _physics_process(_delta):
	update_movement()
	
	pass

func _on_activator_box_body_entered(togglable):
	targeted_activatible = togglable;
	targeting_activatible = true;

func _on_activator_box_body_exited(togglable):
	targeted_activatible = null;
	targeting_activatible = false;
