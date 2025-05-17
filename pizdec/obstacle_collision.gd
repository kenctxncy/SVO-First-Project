extends Area3D


func _on_area_shape_entered(area_rid: RID, area: Area3D, area_shape_index: int, local_shape_index: int) -> void:
	if area.is_in_group("ProjectileCollision"):
		
		$/root/MKMPROJECT1/ProjectContainer/Player/Camera3D.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		area.get_parent().queue_free()
