extends Area3D

@export var trauma_reduction_rate: float = 15.0

@export var max_x: float = 10.0
@export var max_y: float = 10.0
@export var max_z: float = 5.0

@export var noise: FastNoiseLite
@export var noise_speed: float = 50.0

var trauma: float = 0.0
var time: float = 0.0

@onready var camera: Camera3D = $Camera3D
@onready var initial_rotation: Vector3 = camera.rotation_degrees

func _process(delta: float) -> void:
	time += delta
	
	trauma = maxf(
		trauma - delta * trauma_reduction_rate,
		0.0
	)

	var shake := get_shake_intensity()

	camera.rotation_degrees.x = initial_rotation.x + max_x * shake * get_noise_value(0.0)
	camera.rotation_degrees.y = initial_rotation.y + max_y * shake * get_noise_value(100.0)
	camera.rotation_degrees.z = initial_rotation.z + max_z * shake * get_noise_value(200.0)

func add_trauma(amount: float) -> void:
	trauma = clampf(trauma + amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_value(offset: float) -> float:
	if noise == null:
		return 0.0

	return noise.get_noise_1d(time * noise_speed + offset)
	
func clear_trauma() -> void:
	trauma = 0.0
