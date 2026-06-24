extends Node3D

@onready var main: Node3D = $"../../../.."

enum STATE {SPAWNING, TALKING, BATTLEING}
var state: STATE = STATE.SPAWNING

var spawnPos : Array[Vector3] = [Vector3(-30.908, 9.438, -12.735), Vector3(-28.735, 9.438, -11.893)]

enum EMOTIONSTATE {NORMAL, ANGRY}
var emotion : EMOTIONSTATE = EMOTIONSTATE.NORMAL
const OUROBOROS_ANGRY = preload("res://assets/ouroboros/ouroboros_angry.png")
const OUROBOROS_NORMAL = preload("res://assets/ouroboros/ouroboros_normal.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(state == STATE.SPAWNING):
		# move position based on candleTotal
		global_position = spawnPos[0].lerp(
			spawnPos[1],
			clamp(float(main.candleTotal) / 5.0, 0.0, 1.0)
		)
