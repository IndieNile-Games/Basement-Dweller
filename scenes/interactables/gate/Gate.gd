extends StaticBody2D

@export var open: bool = false;
@export var link_code: int = -1;

func process_sprites():
	if (open):
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(1, 2))
	else:
		$Tiles.set_cell(0, Vector2i.ZERO, 2, Vector2i(2, 2))

func process_collision():
	if (open):
		$CollisionBox.set_deferred("disabled", true);
	else:
		$CollisionBox.set_deferred("disabled", false);

func _ready():
	process_collision()
	process_sprites()

func _change_state():
	open = !open;
	process_collision()
	process_sprites()
