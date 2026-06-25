extends Node3D

@export var ouroborus_sps := 2.0
@export var player_spin_power := 5.0

@onready var player: CharacterBody3D = %Player
@onready var progress_bar: ProgressBar = %battleBar
const END_SCREEN = preload("res://scene/endScreen/endScreen.tscn")

var battle_paused : bool = true

var battle_position := 50.0
var last_player_total := 0.0

var in_phase_one = true
var dead = false

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = battle_position

	last_player_total = player.total_spin
	Dialogic.start("res://assets/dialogic/Timeline/battle.dtl")
	Dialogic.signal_event.connect(DialogicSignal)

func _process(delta: float) -> void:
	# Ouroboros constantly pushes left
	
	if(battle_paused):
		return
	battle_position -= ouroborus_sps * delta

	var current_total = player.total_spin
	var spin_gain = current_total - last_player_total

	if spin_gain > 0:
		battle_position += spin_gain * player_spin_power
		%ouroboros.hit()
		if(randi_range(0,1) == 1):
			Audio.play("res://assets/sfx/hiteffect2.ogg")
		else:
			Audio.play("res://assets/sfx/hitEffect.ogg")

	last_player_total = current_total

	battle_position = clampf(battle_position, 0.0, 100.0)

	progress_bar.value = battle_position
	if(progress_bar.value >=90 && in_phase_one):
		Dialogic.start("res://assets/dialogic/Timeline/battle2.dtl")
		ouroborus_sps = 5
		battle_position -= 40
		in_phase_one = false

	if battle_position >= 100.0:
		print("PLAYER WINS")
		dead = true
		%Player.can_move = false
		battle_paused = true
		win()

	elif battle_position <= 0.0:
		print("OUROBOROS WINS")
		Game.currentRoute = "praise"
		get_tree().change_scene_to_packed(END_SCREEN)
		set_process(false)
		
func DialogicSignal(arg: String):
	if(arg == "battle_stop"):
		%Player.can_move = false
		battle_paused = true
		
	elif(arg == "battle_resume"):
		%Player.can_move = true
		battle_paused = false
	else:
		print("does not match dialogic signal")
		
func win() -> void:
	battle_paused = true
	%Player.can_move = false
	Audio.play("res://assets/sfx/ouroboros2.ogg")

	var start_pos = %ouroboros.position
	var end_pos = start_pos + Vector3(0, -15.0, 0)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(%ouroboros, "position", end_pos, 2.0)
	tween.parallel().tween_property(%ouroboros, "rotation:y", %ouroboros.rotation.y + TAU * 6.0, 2.0)

	await tween.finished
	
	await get_tree().create_timer(2.0).timeout

	Game.currentRoute = "fight"
	Game.fightBadge = true
	get_tree().change_scene_to_packed(END_SCREEN)
