extends CharacterBody2D
class_name Player

@export var speed: int = 50
@export var sprint_mult: float = 2
@export var max_health: int = 5;

var health: int = max_health;

var action_box_dist: int = 12;

var targeting_activatible: bool = false;
var targeted_activatible;
var hit_activatable: bool = false;

var direction: Vector2 = Vector2.ZERO
var mouse_pos: Vector2 = (get_global_mouse_position() - global_position).normalized()
var controller_pos: Vector2 = Input.get_vector("ig_wpleft", "ig_wpright", "ig_wpup", "ig_wpdown").normalized()
const controller_deadzone: Vector2 = Vector2(0.5,0.5);

func vector_pothag(vector: Vector2) -> float:
	return sqrt(pow(vector.x, 2) + pow(vector.y, 2))

func update_weapon():
	mouse_pos = (get_global_mouse_position() - global_position).normalized()
	controller_pos = Input.get_vector("ig_wpleft", "ig_wpright", "ig_wpup", "ig_wpdown").normalized()
	
	var rotator: Vector2;
	
	if (abs(vector_pothag(controller_pos)) > vector_pothag(controller_deadzone)): 
		rotator = controller_pos
	else:
		rotator = mouse_pos
	
	$Weapons/PointerParent.rotation = rotator.angle() - 67.5
	$Weapons/MopParent.rotation = rotator.angle() - 67.5

func attack():
	$Audio/Attack.play()
	$Weapons/MopParent/Mop/AnimationPlayer.play("swing")

func _ready():
	update_weapon()
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

	if (targeting_activatible && !hit_activatable):
		hit_activatable = true
		targeted_activatible.toggle(true)
	
	update_weapon()

	move_and_slide()

func _physics_process(_delta):
	update_movement()
	
	if (Input.is_action_just_pressed("ig_attack")):
		attack()

func _on_activator_box_body_entered(togglable):
	targeted_activatible = togglable;
	targeting_activatible = true;

func _on_activator_box_body_exited(togglable):
	targeted_activatible = null;
	hit_activatable = false;
	targeting_activatible = false;
