extends BaseEnemy

@export_category("Bat Config")
@export var speed: int = 50;

var invulnerable: bool = false;
var dead: bool = false;

func attack():
	if (!dead):
		velocity = (target.get_global_position() + position).normalized() * speed
		health = health - 1;
		
		if (health <= 0):
			dead = true;
			emit_signal("enemy_killed")

func _ready():
	if (link_code != -1):
		for actionable in actionables_box.get_children():
			if (link_code == actionable.link_code):
				connect("enemy_killed", actionable._change_state)

func _physics_process(_delta):
	if (targeting):
		velocity = (target.get_global_position() - position).normalized() * speed
	else:
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
		
	move_and_slide()

func _on_player_rect_body_entered(body):
	targeting = true;
	target = body
	$"Room Collision Box".set_deferred("disabled", true);

func _on_hit_box_area_entered(_weapon):
	print("Test Bat")
	if (!invulnerable):
		attack()
		$InvulTimer.start();
		invulnerable = true;

func _on_invul_timer_timeout():
	invulnerable = false;
