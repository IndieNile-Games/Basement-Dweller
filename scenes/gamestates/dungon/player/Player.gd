extends CharacterBody2D
class_name Player

@export var speed: int = 50
@export var sprint_mult: float = 2
@export var max_health: int = 5;
@export var camera: Node2D;
@export var ui_machine: CanvasLayer;

var health: int = max_health;
var was_hit: bool = false;
var dead: bool = false;

var money: int = 0;

var action_box_dist: int = 12;

var targeting_activatible: bool = false;
var targeted_activatible;
var hit_activatable: bool = false;

var game_end: bool = false;

var direction: Vector2 = Vector2.ZERO
var mouse_pos: Vector2 = (get_global_mouse_position() - global_position).normalized()
var controller_pos: Vector2 = Input.get_vector("ig_wpleft", "ig_wpright", "ig_wpup", "ig_wpdown").normalized()
const controller_deadzone: Vector2 = Vector2(0.5,0.5);

enum FacingDirection {
	LEFT, RIGHT
}

var last_direction: FacingDirection = FacingDirection.LEFT;

signal room_cleared();

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
	if (last_direction == FacingDirection.LEFT && direction != Vector2.ZERO):
		$AnimationTree["parameters/Idle/blend_position"] = -1
	elif (last_direction == FacingDirection.RIGHT && direction != Vector2.ZERO):
		$AnimationTree["parameters/Idle/blend_position"] = 1
	
	$AnimationTree["parameters/Moving/blend_position"] = direction
	
	$AnimationTree["parameters/conditions/is_moving"] = velocity != Vector2.ZERO && !dead
	$AnimationTree["parameters/conditions/is_not_moving"] = velocity == Vector2.ZERO || dead
	$AnimationTree["parameters/conditions/is_hit"] = was_hit
	$AnimationTree["parameters/conditions/is_not_hit"] = !was_hit
	$AnimationTree["parameters/conditions/is_dead"] = dead

func _process(_delta):
	update_anim()
	update_health()

func update_movement():
	direction = Input.get_vector("ig_left", "ig_right", "ig_up", "ig_down").normalized()
	
	if direction:
		if (direction.x < 0):
			last_direction = FacingDirection.LEFT
		elif (direction.x > 0):
			last_direction = FacingDirection.RIGHT
		
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
	if (!dead):
		update_movement()
	
		if (Input.is_action_just_pressed("ig_attack")):
			attack()

func _on_activator_box_body_entered(togglable):
	targeted_activatible = togglable;
	targeting_activatible = true;

func _on_activator_box_body_exited(_togglable):
	targeted_activatible = null;
	hit_activatable = false;
	targeting_activatible = false;

func update_health():
	$ProgressBar.value = health
	if ((health == max_health || health == 0) || !just_hide_healthbar):
		$ProgressBar.visible = false;
	else:
		$ProgressBar.visible = true;

func reset():
	health = max_health
	camera.toggle_disable(false)
	$"Collision Box".disabled = false;

func process_damage():
	health = health - 1;
	if (health <= 0 && !dead):
		health = 0
		dead = true
		camera.toggle_disable(true)
		camera.set_bounds(camera.INF_BOUNDS)
		$Weapons/PointerParent.visible = false;
		$Audio/Death.play()
		$"Collision Box".disabled = true;
		$DeathTimer.start()
		get_parent().get_node("CurrentRoom").visible = false;
	else:
		was_hit = true;
		just_hide_healthbar = true;
		$Audio/Hurt.play()
		$InvulTimer.start()
		$HitBarTimer.start()

func _on_hit_box_body_entered(enemy):
	if (!was_hit):
		enemy.attack_freeze()
		process_damage()

func _on_invul_timer_timeout():
	was_hit = false

var just_hide_healthbar: bool = false
func _on_hit_bar_timer_timeout():
	just_hide_healthbar = false

func _on_death_timer_timeout():
	get_tree().change_scene_to_file("res://scenes/ui/menus/Dead.tscn")

func end_game():
	game_end = true;
