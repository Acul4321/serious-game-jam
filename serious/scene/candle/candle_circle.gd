extends Node3D
@export var player: CharacterBody3D
enum PLAYERSTATE {HELD, EMPTY}

enum STATE {PLACED, PICKED}
var state : STATE = STATE.PLACED

const distance : int = 3

signal candle_placed()

func _physics_process(delta: float) -> void:
	if player.global_position.distance_to(self.global_position) < distance && player.currentState == PLAYERSTATE.HELD:
		%placeLabel.visible = true
		if Input.is_action_just_pressed("interact") && !%candle.visible:
			%candle.visible = true
			player.currentState = PLAYERSTATE.EMPTY
			emit_signal("candle_placed")
			Audio.play("res://assets/sfx/player/place.ogg")
	else:
		%placeLabel.visible = false
