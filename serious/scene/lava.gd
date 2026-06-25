extends MeshInstance3D

func _ready() -> void:
	randomize()
	_schedule_next()

func _schedule_next() -> void:
	await get_tree().create_timer(randf_range(2.0, 10.0)).timeout

	# 70% chance to play a bubble sound
	if randf() < 0.9:
		Audio.play("res://assets/sfx/lava.wav")

	_schedule_next()
