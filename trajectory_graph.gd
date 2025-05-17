
extends Control

var maxValues = 900.
var xOffset = 25. * 2.
var sizeX = 485. - xOffset
var sizeY = 220. - xOffset
var minScale = 20.

var values := []
var heights := []

var default_font
var default_font_size

# Деления
var major_division_z = 350 # метры
var major_division_y = 250 # метры

func _ready() -> void:
	default_font = ThemeDB.fallback_font
	default_font_size = ThemeDB.fallback_font_size

func _process(delta: float) -> void:
	if Input.is_action_just_released("launch") && not $/root/MKMPROJECT1/Node3D.is_connected("positionUpdated", _on_positionUpdated):
		$/root/MKMPROJECT1/Node3D.connect("positionUpdated", _on_positionUpdated)

func _on_positionUpdated(z, y):
	add_point(z, y)

func add_point(z: float, y: float) -> void:
	if len(values) >= maxValues:
		values.pop_front()
		heights.pop_front()
	
	values.append(z)
	heights.append(y)
	queue_redraw()

func _draw() -> void:
	draw_string(default_font, Vector2(sizeX/2.15, default_font_size), "Trajectory Graph", HORIZONTAL_ALIGNMENT_RIGHT)
	draw_line(Vector2(xOffset, .0), Vector2(xOffset, sizeY), Color.WHITE)
	draw_line(Vector2(xOffset, sizeY), Vector2(xOffset + sizeX, sizeY), Color.WHITE)
	draw_string(default_font, Vector2(sizeX*2./3.,sizeY+xOffset/1.25), "Z (m)", HORIZONTAL_ALIGNMENT_LEFT)
	
	if len(values) < 2:
		return

	# Вычисляем диапазон Z
	var min_z = min(values.min(), 0.0)
	var max_z = max(values.max(), minScale)
	var range_z = max_z - min_z
	var scale_z = sizeX / range_z

	# Вычисляем масштабы Y
	var max_y = max(heights.max(), minScale)
	var scale_y = sizeY / max_y
	
	# Рисуем сетку и деления по Z
	var current_z = floor(min_z / major_division_z) * major_division_z
	while current_z <= max_z:
		var screen_z = xOffset + (current_z - min_z) * scale_z
		draw_line(Vector2(screen_z, 0), Vector2(screen_z, sizeY), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(screen_z, sizeY + default_font_size), str(current_z), HORIZONTAL_ALIGNMENT_CENTER)
		current_z += major_division_z
	
	# Рисуем сетку и деления по Y
	var steps_y = floor(max_y / major_division_y)
	var last_step_y = steps_y * major_division_y
	var y_div = 0.0
	while y_div <= last_step_y:
		var screen_y = sizeY - y_div * scale_y
		draw_line(Vector2(xOffset, screen_y), Vector2(xOffset + sizeX, screen_y), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(0., screen_y + default_font_size/2.), str(y_div), HORIZONTAL_ALIGNMENT_RIGHT)
		y_div += major_division_y
	
	# Добавляем последнее деление, если оно не совпадает с max_y
	if last_step_y < max_y:
		var screen_y = sizeY - max_y * scale_y
		draw_line(Vector2(xOffset, screen_y), Vector2(xOffset + sizeX, screen_y), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(0., screen_y + default_font_size/2.), str(max_y), HORIZONTAL_ALIGNMENT_RIGHT)
	
	# Рисуем график
	for i in range(1, len(values)):
		var prev_point = Vector2(xOffset + (values[i-1] - min_z) * scale_z, sizeY - heights[i-1] * scale_y)
		var curr_point = Vector2(xOffset + (values[i] - min_z) * scale_z, sizeY - heights[i] * scale_y)
		draw_line(prev_point, curr_point, Color.GREEN)
