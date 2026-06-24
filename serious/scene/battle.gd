extends Node3D

@export var ouroborus_sps := 2.0
@export var player_spin_power := 10.0

@onready var player: CharacterBody3D = %Player
@onready var progress_bar: ProgressBar = %battleBar

var battle_position := 50.0
var last_player_total := 0.0

func _ready() -> void:
	progress_bar.min_value = 0
	progress_bar.max_value = 100
	progress_bar.value = battle_position

	last_player_total = player.total_spin

func _process(delta: float) -> void:
	# Ouroboros constantly pushes left
	battle_position -= ouroborus_sps * delta

	# Detect new player spins
	var current_total = player.total_spin
	var spin_gain = current_total - last_player_total

	if spin_gain > 0:
		battle_position += spin_gain * player_spin_power

	last_player_total = current_total

	battle_position = clampf(battle_position, 0.0, 100.0)

	progress_bar.value = battle_position

	if battle_position >= 100.0:
		print("PLAYER WINS")
		set_process(false)

	elif battle_position <= 0.0:
		print("OUROBOROS WINS")
		set_process(false)
