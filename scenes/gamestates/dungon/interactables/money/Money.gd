extends Area2D
class_name Money

enum Type {
	COINS,
	MONEY_BAG
}

@export var type: Type = Type.COINS;

var value: int;

func process_sprites():
	if (type == Type.COINS):
		$Sprite2D.frame = 8
	else:
		$Sprite2D.frame = 4

func _ready():
	if (type == Type.COINS):
		value = 5
	else:
		value = 25

func _process(delta):
	process_sprites()

func _on_body_entered(player):
	player.money += value
	$CoinSound.play();
	$CollisionShape2D.disabled = true;
	visible = false

func _on_coin_sound_finished():
	queue_free()
