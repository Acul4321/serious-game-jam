extends ProgressBar

@onready var spin_timer: Timer = $"../../Player/SpinTimer"
@onready var player: CharacterBody3D = %Player

func _ready():
	min_value = 0
	max_value = spin_timer.wait_time

func _process(_delta):
	visible = player.needs_to_spin
	if not spin_timer.is_stopped():
		value = spin_timer.time_left
	else:
		value = 0
