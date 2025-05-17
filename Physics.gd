extends Node
# LET THIS END

func _ready() -> void:
	Engine.max_fps = FPS

var ROTATE = deg_to_rad(.5)
const MIN_ANGLE=45
const MAX_ANGLE=85

# Gravitational
var earthRadius = 6371000. #meters
var earthMass = 5.9722*pow(10.,24.)
var G = 6.67430 * pow(10.0,-11.0) # gravitational constant
var densityDelim = 10000.
# ----
# Coriolis (need to figure out what the hell happens there)
var latitude = deg_to_rad(45.5) #45 north degree
var omegaScal = -(2.*PI)/86400. # - if north + if south?
var omega = Vector3(.0,omegaScal*sin(latitude),omegaScal*cos(latitude)) #north
var v_rel = Vector3(omegaScal*earthRadius*cos(latitude),.0,.0)
# ----
var v0 := Vector3(.0,.0,259.) # initial speed of projectile
var v_ust := 250. # stable speed
var v_wind := Vector3(.0,.0,-20.) # wind speed
var g := Vector3(.0, -1.*G*earthMass/pow(earthRadius,2.), .0) # gravity acceleration

var sensivity = 0.001

var FPS = 24
var dtGlobal = fps2s(FPS)

func fps2s(dt: float) -> float: return 1./dt
# --- Physics part ends
