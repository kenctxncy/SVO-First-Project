extends Control

var maxValues = 900. # Максимальное количество точек в буфере
var displayWindow = 40. # Отображаемый интервал времени в секундах
var xOffset = 25. * 2.
var sizeX = 485. - xOffset
var sizeY = 220. - xOffset
var minScale = 20.

var values := []
var times := []

var default_font
var default_font_size

# Деления
var major_division_x = 5 # секунды
var major_division_y = 25 # м/с

func _ready() -> void:
	default_font = ThemeDB.fallback_font
	default_font_size = ThemeDB.fallback_font_size

func _process(delta: float) -> void:
	if Input.is_action_just_released("launch") && not $/root/MKMPROJECT1/Node3D.is_connected("speedUpdated", _on_speedUpdated):
		$/root/MKMPROJECT1/Node3D.connect("speedUpdated", _on_speedUpdated)

func _on_speedUpdated(speed, time):
	add_point(speed, time)

func add_point(val: float, time: float) -> void:
	# Добавляем новую точку
	values.append(val)
	times.append(time)
	
	# Ограничиваем буфер
	if len(values) > maxValues:
		values.pop_front()
		times.pop_front()
	
	queue_redraw()

func _draw() -> void:
	draw_string(default_font, Vector2(sizeX/2., default_font_size), "Speed Graph", HORIZONTAL_ALIGNMENT_RIGHT)
	draw_line(Vector2(xOffset, .0), Vector2(xOffset, sizeY), Color.WHITE)
	draw_line(Vector2(xOffset, sizeY), Vector2(xOffset + sizeX, sizeY), Color.WHITE)
	draw_string(default_font, Vector2(sizeX/2.,sizeY+xOffset/1.25), "Time (s)", HORIZONTAL_ALIGNMENT_LEFT)
	
	if len(values) < 2:
		return

	# Определяем текущий временной диапазон
	var current_time = times[-1]/1000.0
	var start_time = max(current_time - displayWindow, times[0]/1000.0)
	var visible_range = current_time - start_time
	
	# Вычисляем масштабы
	var max_speed = max(values.max(), minScale)
	var scale_x = sizeX / visible_range
	var scale_y = sizeY / max_speed
	
	# Рисуем сетку и деления по X
	var steps_x = floor(visible_range / major_division_x)
	var current_x = start_time
	for i in steps_x + 1:
		var screen_x = xOffset + (current_x - start_time) * scale_x
		draw_line(Vector2(screen_x, 0), Vector2(screen_x, sizeY), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(screen_x, sizeY + default_font_size), str(current_x), HORIZONTAL_ALIGNMENT_CENTER)
		current_x += major_division_x
	
	# Рисуем сетку и деления по Y
	var steps_y = floor(max_speed / major_division_y)
	var y_div = 0.0
	while y_div <= max_speed:
		var screen_y = sizeY - y_div * scale_y
		draw_line(Vector2(xOffset, screen_y), Vector2(xOffset + sizeX, screen_y), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(0., screen_y + default_font_size/2.), str(y_div), HORIZONTAL_ALIGNMENT_RIGHT)
		y_div += major_division_y
	
	# Добавляем последнее деление, если оно не совпадает с max_speed
	if steps_y * major_division_y < max_speed:
		var screen_y = sizeY - max_speed * scale_y
		draw_line(Vector2(xOffset, screen_y), Vector2(xOffset + sizeX, screen_y), Color(1,1,1,0.2))
		draw_string(default_font, Vector2(0., screen_y + default_font_size/2.), str(max_speed), HORIZONTAL_ALIGNMENT_RIGHT)
	
	# Рисуем график
	for i in range(1, len(values)):
		# Пропускаем точки вне текущего диапазона
		if times[i-1]/1000.0 < start_time or times[i]/1000.0 < start_time:
			continue
		
		var prev_time = times[i-1]/1000.0 - start_time
		var curr_time = times[i]/1000.0 - start_time
		var prev_point = Vector2(xOffset + prev_time * scale_x, sizeY - values[i-1] * scale_y)
		var curr_point = Vector2(xOffset + curr_time * scale_x, sizeY - values[i] * scale_y)
		draw_line(prev_point, curr_point, Color.RED)
