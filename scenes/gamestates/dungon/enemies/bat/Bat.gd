extends CharacterBody2D

@export var speed: int = 50;
@export var link_code: int = -1;

@export var max_health: int = 2;

@onready var actionables_box: Node2D = get_parent().get_parent().get_node("Interactables").get_node("Props")

var health: int = max_health;

var targeting: bool = false;
var target: Node2D;

var player_direction: Vector2;
var movement_direction: Vector2;

var was_hit: bool = false;

signal enemy_dead();

func _ready():
	$AnimationPlayer.play("default")
	
	if (link_code != -1):
		for actionable in actionables_box.get_children():
			if (link_code == actionable.link_code):
				connect("enemy_dead", actionable._change_state)

func _physics_process(_delta):
	if (!was_hit):
		if (targeting):
			player_direction = (target.get_global_position() - position).normalized() * speed
			movement_direction = lerp(movement_direction, player_direction, 0.2)
		else:
			movement_direction = lerp(movement_direction, Vector2.ZERO, 0.07)
		
		velocity = movement_direction;
	else:
		velocity = lerp(movement_direction, Vector2.ZERO, 0.07);
		
	move_and_slide()

func _on_player_rect_body_entered(body):
	targeting = true;
	target = body
	$"Room Collision Box".set_deferred("disabled", true);

func _on_hit_box_body_entered(body):
	if (!was_hit):
		$AnimationPlayer.play("damaged")
		$HurtTimer.start()
		movement_direction = movement_direction * -1
		was_hit = true;

func _on_hurt_timer_timeout():
	$AnimationPlayer.play("default")
	was_hit = false;
