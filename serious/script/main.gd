extends Node3D

var candleTotal : int = 0
@onready var cutscene_player: AnimationPlayer = $Cutscene/cutscenePlayer

@onready var world_environment: WorldEnvironment = %WorldEnvironment

const START_TOP := Color("#7158d7")
const START_HORIZON := Color("#969ff0")

const END_TOP := Color("#871400")
const END_HORIZON := Color("#ff7d3c")

var colour_speed := 2.0

var current_top: Color
var current_horizon: Color

const BATTLE = preload("res://scene/battle.tscn")
const END_SCREEN = preload("res://scene/endScreen/endScreen.tscn")

@onready var ouroboros_camera: Camera3D = $Cutscene/ouroborosCameraArea/ouroborosCamera
@onready var battle_camera: Camera3D = $Cutscene/battleCamera/Camera3D2

@onready var news_camera: Camera3D = $Cutscene/ShakeableCamera2/Camera3D2
@onready var shakeable_camera: Camera3D = $Cutscene/ShakeableCamera/Camera3D
@onready var shake: Area3D = $Cutscene/ShakeableCamera

@onready var playerCamera: Camera3D = $view/Camera

enum GAMESTATE {NEWS, GAMEPLAY, SPAWNING, TALKING, BATTLEING}
var state : GAMESTATE = GAMESTATE.NEWS

var in_help : bool = false
var finished : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Audio.stop("res://assets/music/menu_song_serpents_promise.ogg")
	#hookup dialogic signal for choices
	Dialogic.signal_event.connect(DialogicSignal)
	# set sky colour
	current_top = START_TOP
	current_horizon = START_HORIZON
	#on news start
	shake.add_trauma(1)
	Dialogic.timeline_ended.connect(news_ended)
	Dialogic.start("res://assets/dialogic/timeline/news.dtl")
	cutscene_player.play("news")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(candleTotal <= 0):
		%ouroboros.visible = false
	if(state == GAMESTATE.NEWS):
		news_camera.make_current()
		%Player.needs_to_spin = false
		%Player.can_move = false
	elif(state == GAMESTATE.SPAWNING):
		shakeable_camera.make_current()
		%Player.needs_to_spin = false
		%Player.can_move = false
		
	elif(state == GAMESTATE.TALKING):
		ouroboros_camera.make_current()
		%Player.needs_to_spin = false
		%Player.can_move = false
	elif(state == GAMESTATE.BATTLEING):
		battle_camera.make_current()
		%Player.needs_to_spin = false
		
	elif(state == GAMESTATE.GAMEPLAY):
		playerCamera.make_current()
		%Player.needs_to_spin = true
		%Player.can_move = true
		if(in_help && !finished):
			%Player.needs_to_spin = false
			%Player.can_move = false
		if(%Player.dead && !in_help):
			%Player.needs_to_spin = false
			%Player.can_move = false
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
		change_state(GAMESTATE.TALKING)
		Dialogic.start("res://assets/dialogic/timeline/ouroboros.dtl")
	else:
		change_state(GAMESTATE.SPAWNING)
		cutscene_player.play("spawning")
		
func change_state(newState:GAMESTATE):
	state = newState


func _on_platform_rise_end() -> void:
	print("platform end")
	shake.clear_trauma()
	
func news_ended():
	#magic number - rough estimate of time if the player mashes to skip
	if(cutscene_player.current_animation_position < 10):
		cutscene_player.seek(25.0)
	print("ended")
	Audio.play("res://assets/music/menu_song_serpents_promise.ogg")
	Dialogic.timeline_ended.disconnect(news_ended)
	Dialogic.start("res://assets/dialogic/timeline/cultHelp.dtl")

func DialogicSignal(arg: String):
	if(arg == "serve_signal"):
		print("serve")
		Game.praiseBadge = true
		Game.currentRoute = "praise"
		get_tree().change_scene_to_packed(END_SCREEN)
		
	elif(arg == "fight_signal"):
		print("fight")
		change_state(GAMESTATE.BATTLEING)
		cutscene_player.play("battleing")
		
	elif(arg == "startHelp"):
		in_help = true
		%Player.needs_to_spin = false
		%Player.can_move = false
		
	elif(arg == "endHelp"):
		in_help = false
		finished = true
		%Player.needs_to_spin = true
		%Player.can_move = true
	else:
		print("does not match dialogic signal")
	
func change_to_battle_scene():
	get_tree().change_scene_to_packed(BATTLE)

func let_player_walk_spin():
	%Player.needs_to_spin = true
	%Player.can_move = true
