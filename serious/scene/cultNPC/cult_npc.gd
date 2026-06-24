extends Node3D

const ROTATION_SPEED : float = 5.0

@export var player: CharacterBody3D

const distance : int = 2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = Vector3i(0, randi_range(0,360), 0)
	%cultModel/AnimationPlayer.play("praise_up_animation", 0.1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation.y += ROTATION_SPEED * delta
	if player.global_position.distance_to(self.global_position) < distance:
		%talkLabel.visible = true
		if Input.is_action_just_pressed("interact"):
			pass
			#Dialogic.start("cultMembers")
	else:
		%talkLabel.visible = false
