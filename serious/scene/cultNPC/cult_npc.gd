extends Node3D

const ROTATION_SPEED : float = 5.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = Vector3i(0, randi_range(0,360), 0)
	%cultModel/AnimationPlayer.play("praise_up_animation", 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y += ROTATION_SPEED * delta
