extends Node2D

@export var player: Player;

@onready var tilemap: TileMap = get_child(0).get_child(0)

var tile_rect: Rect2i;
var tile_data: TileData;
var start_found: bool = false;

# Called when the node enters the scene tree for the first time.
func _ready():
	tile_rect = tilemap.get_used_rect()
	
	for x in range(tile_rect.position.x, tile_rect.end.x):
		for y in range(tile_rect.position.y, tile_rect.end.y):
			# print(Vector2i(x,y))
			tile_data = tilemap.get_cell_tile_data(0, Vector2i(x, y));
			if (tile_data != null):
				print(tile_data.get_custom_data("interaction_type"))
				if (tile_data.get_custom_data("interaction_type") == 1):
					player.position = Vector2((x * tilemap.tile_set.tile_size[0]) + tilemap.tile_set.tile_size[0]/2, (y * tilemap.tile_set.tile_size[1]) + tilemap.tile_set.tile_size[1]/2)
					start_found = true;
					break;
		if (start_found): break;
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
