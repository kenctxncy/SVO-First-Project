extends CharacterBody3D

var Throwable := preload("res://MortarShell.tscn")
@onready var MortarContainer = $PlayerCollision/MortarContainer
@onready var MortarShellPos = $PlayerCollision/MortarContainer/MortarShellPos

signal rotationUpdated(rotationX, rotationY)

func _ready() -> void:
	print_tree_pretty()
	#var playerUI = get_tree().current_scene.get_node("UI")
	#playerUI.connect("resetPosition", _on_positionReset)

func _physics_process(delta: float = Physics.dtGlobal) -> void:
	#var Camera := get_child(1)
	
	if Input.is_action_pressed("rotate_left"):
		rotate_y(Physics.ROTATE)
		emit_signal("rotationUpdated", -MortarContainer.rotation.x, rotation.y)
	if Input.is_action_pressed("rotate_right"):
		rotate_y(-Physics.ROTATE)
		emit_signal("rotationUpdated", -MortarContainer.rotation.x, rotation.y)
	if Input.is_action_pressed("lower_degree") && MortarContainer.rotation.x>deg_to_rad(-Physics.MAX_ANGLE): # highest angle is 85 degree, converted to RAD
		MortarContainer.rotate_x(-Physics.ROTATE)
		emit_signal("rotationUpdated", -MortarContainer.rotation.x, rotation.y)
	if Input.is_action_pressed("add_degree") && MortarContainer.rotation.x<deg_to_rad(-Physics.MIN_ANGLE): # the default value of model is 45 degree
		MortarContainer.rotate_x(Physics.ROTATE)
		emit_signal("rotationUpdated", -MortarContainer.rotation.x, rotation.y)

	itemThrow(MortarContainer.rotation.x, rotation.y, MortarShellPos.global_position, MortarContainer.global_transform.basis.z)

func itemThrow(rad_Hset, rad_Vset, launch_vec, orientation_vec):
	if Input.is_action_just_released("launch"):
		var Item = Throwable.instantiate()
		Item.v = orientation_vec.normalized() * Physics.v0.length()
		Item.r = launch_vec
		Item.rotation.x += rad_Hset
		Item.rotation.y += rad_Vset
		get_tree().current_scene.add_child(Item)
		Item.get_node("Distance/ProjectileCamera").current = true
#
#func _on_positionReset (rotXDef, rotYDef):
	#MortarContainer.rotation.x = rotXDef
	#rotation.y = rotYDef
