extends Node3D
var r; var v; var a := Vector3.ZERO; var isTest := false
# direction vector; speed; acceleration; bools; array of dots 
# Called when the node enters the scene tree for the first time.

signal speedUpdated(speed, time)
signal positionUpdated(z, y)
signal deviationUpdated(x, y)

func _ready() -> void:
	print_tree_pretty()
	# Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float = Physics.dtGlobal) -> void:
	print("Projectile position: ", global_position)
	print("Projectile Y rotation: ", rotation.y)
	print("Projectile X rotation: ", rad_to_deg(rotation.x))
	var vPrev = v
	var r_new = verlet_position(r,v,a,delta)
	var v_pred = v + a * delta
	var a_new = accel_z(v_pred, r_new.y)
	v = verlet_velocity(v,a,a_new,delta)
	print("Speed vec: ", v, "; Speed val: ", v.length())
	speedUpdated.emit(v.length(), Time.get_ticks_msec())
	r = r_new
	a = a_new
	global_position = r
	var rotation_axis = vPrev.normalized().cross(v.normalized())
	var rotation_angle = vPrev.angle_to(v)
	if rotation_axis.length() > 0:
		rotate(rotation_axis.normalized(), rotation_angle)
	positionUpdated.emit(global_position.z,global_position.y)
	deviationUpdated.emit(global_position.z,global_position.x)
func verlet_position(r, v, a, dt) -> Vector3:
	return r + v * dt + .5 * a * dt * dt

func verlet_velocity(v, a_old, a_new, dt) -> Vector3:
	return v + (a_old + a_new) * .5 * dt

func accel_z(v_pred, h) -> Vector3:
	var u = v_pred-Physics.v_wind
	var u_rel = u-Physics.v_rel
	var a_coriolis = 2.*Physics.omega.cross(u_rel)
	print("Coriolis acceleration: ", a_coriolis)
	return -Physics.g.length()*exp(-h/Physics.densityDelim)*((u.length()*u)/pow(Physics.v_ust,2.))+Physics.g+a_coriolis

func accel_test(v_ust, dt): #doesnt work with my mortar shell physics process?
	return Physics.v_ust*tanh((Physics.g.length()*dt)/Physics.v_ust)
# todo: stabilization of projectile (aerofocus?); coriolis force for X derivation
