extends Node3D

var candleTotal : int = 0

@onready var world_environment: WorldEnvironment = %WorldEnvironment

const START_TOP := Color("#7158d7")
const START_HORIZON := Color("#969ff0")

const END_TOP := Color("#871400")
const END_HORIZON := Color("#ff7d3c")

var colour_speed := 2.0

var current_top: Color
var current_horizon: Color

@onready var shakeable_camera: Camera3D = $Cutscene/ShakeableCamera/Camera3D
@onready var shake: Area3D = $Cutscene/ShakeableCamera

@onready var playerCamera: Camera3D = $view/Camera

enum GAMESTATE {NEWS, GAMEPLAY, SPAWNING, TALKING, BATTLEING}
var state : GAMESTATE = GAMESTATE.NEWS

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# set sky colour
	current_top = START_TOP
	current_horizon = START_HORIZON

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(state == GAMESTATE.NEWS):
		shakeable_camera.make_current()
		shake.add_trauma(1)
		Dialogic.start("news")
	elif(state == GAMESTATE.GAMEPLAY):
		playerCamera.make_current()
	#sky colour changing
	var t := clampf(float(candleTotal) / 5.0, 0.0, 1.0)

	var target_top := START_TOP.lerp(END_TOP, t)
	var target_horizon := START_HORIZON.lerp(END_HORIZON, t)

	current_top = current_top.lerp(target_top, colour_speed * delta)
	current_horizon = current_horizon.lerp(target_horizon, colour_speed * delta)

	var sky := world_environment.environment.sky.sky_material as ProceduralSkyMaterial
	if sky:
		sky.sky_top_color = current_top
		sky.sky_horizon_color = current_horizon


func _on_candle_circle_candle_placed() -> void:
	print("candle placed")
	candleTotal += 1
	if candleTotal >= 5:
		print("game end")
		
func change_state(newState:GAMESTATE):
	state = newState


func _on_platform_rise_end() -> void:
	print("platform end")
	shake.clear_trauma()
