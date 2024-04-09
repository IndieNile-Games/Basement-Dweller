extends Area2D
class_name Exit

func _on_body_entered(player):
	player.end_game()
