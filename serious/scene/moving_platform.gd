extends Node3D

@export var path: Path3D
@export var speed: float = 2.0
@export var loop: bool = true

var distance_travelled: float = 0.0
var direction : float = 1.0

func _process(delta: float) -> void:
	if path == null:
		return

	var curve := path.curve
	if curve == null:
		return

	var path_length := curve.get_baked_length()

	distance_travelled += speed * direction * delta

	if loop:
		distance_travelled = fmod(distance_travelled, path_length)
	else:
		distance_travelled = min(distance_travelled, path_length)
		
	# Reverse direction at the ends
	if distance_travelled >= path_length:
		distance_travelled = path_length
		direction = -1.0
	elif distance_travelled <= 0.0:
		distance_travelled = 0.0
		direction = 1.0

	global_position = curve.sample_baked(distance_travelled)
