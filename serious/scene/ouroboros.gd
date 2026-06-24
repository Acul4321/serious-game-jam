extends Node3D

@onready var main: Node3D = $"../../../.."

enum STATE {SPAWNING, TALKING, BATTLEING}
var state: STATE = STATE.SPAWNING

var spawnPos: Array[Vector3] = [
	Vector3(-30.908, 9.438, -12.735),
	Vector3(-28.735, 9.438, -11.893)
]

func _process(delta: float) -> void:
	if state == STATE.SPAWNING:
		var target_position := spawnPos[0].lerp(
			spawnPos[1],
			clamp(float(main.candleTotal) / 5.0, 0.0, 1.0)
		)

		# Smoothly move towards target (≈2 second transition)
		global_position = global_position.lerp(target_position, delta / 2.0)
