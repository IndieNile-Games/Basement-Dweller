extends CharacterBody2D
class_name Bat

@export var speed: int = 50;
@export var link_code: int = -1;

@export var big: bool = false

@onready var actionables_box: Node2D = get_parent().get_parent().get_node("Interactables").get_node("Props")

@export var max_health: int = 3;
var health: int = max_health;

var targeting: bool = false;
var target: Node2D;

var player_direction: Vector2;
var movement_direction: Vector2;

var was_hit: bool = false;
@export var dead: bool = false;

@export var frozen: bool = false;

signal enemy_dead();

func _ready():
	$"Targeting Box/CollisionShape2D2".disabled = !big
	$"Targeting Box/CollisionShape2D".disabled = big
	
	$AnimationPlayer.play("idle")
	health = max_health
	if (link_code != -1):
		for actionable in actionables_box.get_children():
			if (link_code == actionable.link_code):
				connect("enemy_dead", actionable._change_state)

func _process(_delta):
	if (!targeting): $Sprite2D.offset = lerp($Sprite2D.offset, Vector2.ZERO, 0.07)

func _physics_process(_delta):
	
	if (!was_hit && !dead && !frozen):
		if (targeting):
			player_direction = (target.get_global_position() - position).normalized() * speed
			movement_direction = lerp(movement_direction, player_direction, 0.2)
		else:
			movement_direction = Vector2.ZERO
		
		velocity = movement_direction;
	elif (frozen):
		movement_direction = lerp(movement_direction, Vector2.ZERO, 0.04);
		velocity = lerp(movement_direction, Vector2.ZERO, 0.07);
	else:
		velocity = lerp(movement_direction, Vector2.ZERO, 0.07);
		
	move_and_slide()

func _on_player_rect_body_entered(body):
	targeting = true;
	target = body
	$AnimationPlayer.play("default")
	# $"Room Collision Box".set_deferred("disabled", true);

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

func _on_hit_box_body_entered(_Wbody):
	if (!was_hit && !dead):
		process_hit()

func _on_hurt_timer_timeout():
	if (!dead): $AnimationPlayer.play("default")
	was_hit = false;

func _on_dead_timer_timeout():
	queue_free()

func attack_freeze(permanant: bool = false):
	frozen = true
	movement_direction = -movement_direction
	if (!permanant): $AttackWaitTimer.start();

func _on_attack_wait_timer_timeout():
	frozen = false
