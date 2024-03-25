extends CharacterBody2D

@export var speed: int = 200

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("ui_left", "ui_right")
	if direction_x:
		velocity.x = direction_x * speed * delta * 10
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		
	var direction_y = Input.get_axis("ui_up", "ui_down")
	if direction_y:
		velocity.y = direction_y * speed * delta * 10
	else:
		velocity.y = move_toward(velocity.y, 0, speed)

	move_and_slide()
