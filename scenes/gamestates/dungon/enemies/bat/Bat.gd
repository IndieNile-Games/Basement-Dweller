extends CharacterBody2D

@export var speed: int = 50;
@export var link_code: int = -1;

@onready var actionables_box: Node2D = get_parent().get_parent().get_node("Interactables").get_node("Props")

@export var max_health: int = 2;
var health: int = max_health;

var targeting: bool = false;
var target: Node2D;

var player_direction: Vector2;
var movement_direction: Vector2;

var was_hit: bool = false;
@export var dead: bool = false;

signal enemy_dead();

func _ready():
	$AnimationPlayer.play("idle")
	
	if (link_code != -1):
		for actionable in actionables_box.get_children():
			if (link_code == actionable.link_code):
				connect("enemy_dead", actionable._change_state)

func _physics_process(_delta):
	if (!was_hit && !dead):
		if (targeting):
			player_direction = (target.get_global_position() - position).normalized() * speed
			movement_direction = lerp(movement_direction, player_direction, 0.2)
		else:
			movement_direction = Vector2.ZERO
			
		
		velocity = movement_direction;
	else:
		velocity = lerp(movement_direction, Vector2.ZERO, 0.07);
		
	move_and_slide()

func _on_player_rect_body_entered(body):
	targeting = true;
	target = body
	$AnimationPlayer.play("default")
	$"Room Collision Box".set_deferred("disabled", true);

func process_hit():
	health = health - 1
	
	if (health <= 0):
		health = 0
		dead = true;
		movement_direction = Vector2.ZERO
		$AnimationPlayer.play("death")
		$DeadTimer.start()
		$Audio/Death.play()
		emit_signal("enemy_dead")
	else:
		$AnimationPlayer.play("damaged")
		$HurtTimer.start()
		$Audio/Hurt.play()
		movement_direction = movement_direction * -1
		was_hit = true;

func _on_hit_box_body_entered(body):
	if (!was_hit && !dead):
		process_hit()

func _on_hurt_timer_timeout():
	if (!dead): $AnimationPlayer.play("default")
	was_hit = false;

func _on_dead_timer_timeout():
	queue_free()
