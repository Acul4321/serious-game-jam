extends MeshInstance3D

@export var scroll_direction: Vector3 = Vector3.FORWARD
@export var scroll_speed: float = 0.25

func _process(delta: float) -> void:
	global_position += scroll_direction.normalized() * scroll_speed * delta
func _ready() -> void:
	randomize()
	_schedule_next()

func _schedule_next() -> void:
	await get_tree().create_timer(randf_range(2.0, 10.0)).timeout

	# 70% chance to play a bubble sound
	if randf() < 0.9:
		Audio.play("res://assets/sfx/lava.wav")

	_schedule_next()
