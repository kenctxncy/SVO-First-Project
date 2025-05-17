extends SpringArm3D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event: InputEvent) -> void:
	if $ProjectileCamera.current == true:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				rotation.y -= event.relative.x * Physics.sensivity
				rotation.x -= event.relative.y * Physics.sensivity
			if event.is_action_pressed("zoom_in"):
				spring_length -= 1
			if event.is_action_pressed("zoom_out"):
				spring_length += 1
		if event.is_action_pressed("cursor_escape"):
				if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
					Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				else:
					Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
