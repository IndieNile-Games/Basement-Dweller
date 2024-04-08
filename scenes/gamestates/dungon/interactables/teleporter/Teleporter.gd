extends Area2D
class_name Teleporter

enum Type {
	SENDER,
	RECIEVER
}

@export var link_code: int = -1
@export var linked_teleporter: Teleporter;
@export var active: bool = true
@export var type: Type = Type.SENDER

var is_active: bool = active

func update_animation():
	if (is_active):
		if (type == Type.SENDER):
			$AnimationPlayer.play("from");
		else:
			$AnimationPlayer.play("to");
	else:
		$AnimationPlayer.play("off");

func _process(_delta):
	update_animation()

func _change_state():
	print("Test")
	is_active = !is_active

func _on_body_entered(body):
	if (type == Type.SENDER):
		body.position = linked_teleporter.position;
