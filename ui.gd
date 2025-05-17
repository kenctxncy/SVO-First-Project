extends CanvasLayer
# -- values
@onready var dtSlider = $Layout/PhysicsContainer/ColorRect/Switches/dtContainer/dtSlider
@onready var FPSSlider = $Layout/PhysicsContainer/ColorRect/Switches/FPSContainer/FPSSlider
@onready var gSlider = $Layout/PhysicsContainer/ColorRect/Switches/gContainer/gSlider
@onready var v0Slider = $Layout/PhysicsContainer/ColorRect/Switches/v0Container/v0Slider
@onready var vUstSlider = $Layout/PhysicsContainer/ColorRect/Switches/vUstContainer/vUstSlider
@onready var airDensitySlider = $Layout/PhysicsContainer/ColorRect/Switches/airDensityContainer/airDensitySlider

@onready var windZVelocity = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindZContainer/HSliderZ
@onready var windYVelocity = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindYContainer/HSliderY
@onready var windXVelocity = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindXContainer/HSliderX

#@onready var speedGraph = $Layout/PhysicsContainer/ColorRect2/SpeedGraph
#@onready var trajectoryGraph = $Layout/PhysicsContainer/ColorRect3/TrajectoryGraph
#@onready var deviationGraph = $Layout/PhysicsContainer/ColorRect4/DeviationGraph
# -- labels
@onready var dtLabel = $Layout/PhysicsContainer/ColorRect/Switches/dtContainer/dtValue
@onready var FPSLabel = $Layout/PhysicsContainer/ColorRect/Switches/FPSContainer/FPSValue
@onready var gLabel = $Layout/PhysicsContainer/ColorRect/Switches/gContainer/gValue
@onready var v0Label = $Layout/PhysicsContainer/ColorRect/Switches/v0Container/v0Value
@onready var vUstLabel = $Layout/PhysicsContainer/ColorRect/Switches/vUstContainer/vUstValue
@onready var airDensityLabel = $Layout/PhysicsContainer/ColorRect/Switches/airDensityContainer/airDensityValue

@onready var WindZLabel = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindZContainer/WindZValue
@onready var WindYLabel = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindYContainer/WindYValue
@onready var WindXLabel = $Layout/PhysicsContainer/ColorRect/Switches/WindSpeed/WindXContainer/WindXValue

@onready var XRotationMortar = $Layout/InfoContainer/XRotationLabel
@onready var YRotationMortar = $Layout/InfoContainer/YRotationLabel
# -- buttons
@onready var testButton = $Layout/PhysicsContainer/ColorRect/Switches/TestButton
@onready var resetButton = $Layout/PhysicsContainer/ColorRect/Switches/ResetButton

var defaults = {}

func _ready() -> void:
	print_tree_pretty() # debugging purposes
	
	var player = get_tree().current_scene.get_node("ProjectContainer/Player")
	player.connect("rotationUpdated", _on_playerRotation_updated)
	windZVelocity.value = Physics.v_wind.z
	windYVelocity.value = Physics.v_wind.y
	windXVelocity.value = Physics.v_wind.x
	
	FPSSlider.value = Physics.FPS
	dtSlider.value = Physics.dtGlobal
	gSlider.value = Physics.g.y
	airDensitySlider.value = Physics.densityDelim
	
	v0Slider.value = Physics.v0.z
	vUstSlider.value = Physics.v_ust
	
	XRotationMortar.text = "X Rotation: " + str(45.) + ".\nMIN: " + str(Physics.MIN_ANGLE) + ";\nMAX: " + str(Physics.MAX_ANGLE)
	YRotationMortar.text = "Y Rotation: " + str(0.)
	
	defaults = {
		"dt": dtSlider.value,
		"FPS": FPSSlider.value,
		"g": gSlider.value,
		"v0": v0Slider.value,
		"vUst": vUstSlider.value,
		"v_wind": Vector3(
			windXVelocity.value, windYVelocity.value, windZVelocity.value
		),
		"densityDelim": airDensitySlider.value,
	}
	
	update_labels()

func _on_densityDelim_value_changed(value):
	Physics.densityDelim = airDensitySlider.value
	update_labels()

func _on_densityDelim_text_submitted(value):
	airDensitySlider.value = float(airDensityLabel.text)

func _on_dtSlider_value_changed(value):
	Physics.dtGlobal = dtSlider.value
	update_labels()

func _on_dtValue_text_submitted(value):
	dtSlider.value = float(dtLabel.text)
	
func _on_FPSSlider_value_changed(value):
	Physics.FPS = FPSSlider.value
	Physics._ready()
	dtSlider.value = Physics.fps2s(Physics.FPS)
	Physics.dtGlobal = dtSlider.value
	update_labels()
	
func _on_FPSValue_text_submitted(value):
	FPSSlider.value = float(FPSLabel.text)

func _on_gSlider_value_changed(value):
	Physics.g.y = gSlider.value
	update_labels()

func _on_gValue_text_submitted(value):
	gSlider.value = float(gLabel.text)

func _on_v0Slider_value_changed(value):
	Physics.v0.z = v0Slider.value
	update_labels()

func _on_v0Value_text_submitted(value):
	v0Slider.value = float(v0Label.text)

func _on_vUstSlider_value_changed(value):
	Physics.v_ust = vUstSlider.value
	update_labels()

func _on_vUstValue_text_submitted(value):
	vUstSlider.value = float(vUstLabel.text)

func _on_windlabel_changed(value):
	windXVelocity.value = float(WindXLabel.text)
	windYVelocity.value = float(WindYLabel.text)
	windZVelocity.value = float(WindZLabel.text)
	
func _on_windslider_changed(value):
	Physics.v_wind = Vector3(
		windXVelocity.value,
		windYVelocity.value,
		windZVelocity.value
		)
	update_labels()

func update_labels():
	dtLabel.text = str(dtSlider.value)
	FPSLabel.text = str(FPSSlider.value)
	gLabel.text = str(gSlider.value)
	v0Label.text = str(v0Slider.value)
	vUstLabel.text = str(vUstSlider.value)
	airDensityLabel.text = str(airDensitySlider.value)

	WindZLabel.text = str(windZVelocity.value)
	WindXLabel.text = str(windXVelocity.value)
	WindYLabel.text = str(windYVelocity.value)

func _on_playerRotation_updated(rotation_x, rotation_y):
	XRotationMortar.text = "X Rotation: " + str(rad_to_deg(rotation_x)) + ".\nMIN: " + str(Physics.MIN_ANGLE) + ";\nMAX: " + str(Physics.MAX_ANGLE)
	YRotationMortar.text = "Y Rotation: " + str(rad_to_deg(rotation_y))

func _on_ResetButton_pressed() -> void:
	Physics.dtGlobal = defaults["dt"]
	Physics.FPS = defaults["FPS"]
	Physics.g.y = defaults["g"]
	Physics.v0.z = defaults["v0"]
	Physics.v_ust = defaults["vUst"]
	Physics.v_wind = defaults["v_wind"]
	Physics.densityDelim = defaults["densityDelim"]
	
	_ready()
