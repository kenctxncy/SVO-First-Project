extends Control

var maxValues = 900.
var xOffset = 25. * 2.
var sizeX = 485. - xOffset
var sizeY = 220. - xOffset
var minScale = 20.

var x_values := [] # Отклонение по оси X (ордината)
var z_values := [] # Отклонение по оси Z (абсцисса)

var default_font
var default_font_size

# Деления
var major_division_x = 50 # метры (ось X)
var major_division_z = 350 # метры (ось Z)

func _ready() -> void:
	default_font = ThemeDB.fallback_font
	default_font_size = ThemeDB.fallback_font_size

func _process(delta: float) -> void:
	if Input.is_action_just_released("launch") && not $/root/MKMPROJECT1/Node3D.is_connected("deviationUpdated", _on_deviationUpdated):
		$/root/MKMPROJECT1/Node3D.connect("deviationUpdated", _on_deviationUpdated)

func _on_deviationUpdated(z, x):
	add_point(z, x)

func add_point(z: float, x: float) -> void:
	if len(x_values) >= maxValues:
		x_values.pop_front()
		z_values.pop_front()
	
	x_values.append(x)
	z_values.append(z)
	queue_redraw()

func _draw() -> void:
	draw_string(default_font, Vector2(sizeX/2.15, default_font_size), "Deviation Graph", HORIZONTAL_ALIGNMENT_RIGHT)
	
	if len(x_values) < 2:
		return

	# Определяем диапазоны
	var min_x = min(x_values.min(), -minScale)
	var max_x = max(x_values.max(), minScale)
	var range_x = max_x - min_x
	var scale_x = sizeY / range_x # Ось X - вертикальная
	
	var min_z = min(z_values.min(), -minScale)
	var max_z = max(z_values.max(), minScale)
	var range_z = max_z - min_z
	var scale_z = sizeX / range_z # Ось Z - горизонтальная

	# Вычисляем позицию нуля
	var screen_zero_x = xOffset + (0 - min_z) * scale_z
	var screen_zero_y = sizeY - (0 - min_x) * scale_x

	# Рисуем оси координат
	draw_line(Vector2(xOffset, screen_zero_y), Vector2(xOffset + sizeX, screen_zero_y), Color.WHITE) # Ось Z
	draw_line(Vector2(screen_zero_x, 0), Vector2(screen_zero_x, sizeY), Color.WHITE) # Ось X

	# Рисуем деления и сетку по оси Z
	var current_z = floor(min_z / major_division_z) * major_division_z
	while current_z <= max_z:
		var screen_z = xOffset + (current_z - min_z) * scale_z
		draw_line(Vector2(screen_z, 0), Vector2(screen_z, sizeY), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(screen_z, screen_zero_y + default_font_size), str(current_z), HORIZONTAL_ALIGNMENT_CENTER)
		current_z += major_division_z

	# Рисуем деления и сетку по оси X
	var current_x = floor(min_x / major_division_x) * major_division_x
	while current_x <= max_x:
		var screen_x = sizeY - (current_x - min_x) * scale_x
		draw_line(Vector2(xOffset, screen_x), Vector2(xOffset + sizeX, screen_x), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(screen_zero_x - default_font_size, screen_x), str(current_x), HORIZONTAL_ALIGNMENT_RIGHT)
		current_x += major_division_x

	# Рисуем график
	for i in range(1, len(x_values)):
		var prev_point = Vector2(
			xOffset + (z_values[i-1] - min_z) * scale_z,
			sizeY - (x_values[i-1] - min_x) * scale_x
		)
		var curr_point = Vector2(
			xOffset + (z_values[i] - min_z) * scale_z,
			sizeY - (x_values[i] - min_x) * scale_x
		)
		draw_line(prev_point, curr_point, Color.LIGHT_BLUE)
