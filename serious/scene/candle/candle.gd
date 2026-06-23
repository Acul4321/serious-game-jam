extends Node3D
@export var player: CharacterBody3D
enum PLAYERSTATE {HELD, EMPTY}

enum STATE {PLACED, PICKED}
var state : STATE = STATE.PLACED

const distance : int = 3 

func _physics_process(delta: float) -> void:
	var labelVisibility = false
	if player.global_position.distance_to(self.global_position) < distance && player.currentState == PLAYERSTATE.EMPTY:
		labelVisibility = true
		if Input.is_action_just_pressed("interact"):
			%candle.visible = !%candle.visible
			if %candle.visible:
				player.currentState = PLAYERSTATE.EMPTY
			else:
				player.currentState = PLAYERSTATE.HELD
				
			print(player.currentState)
			
			
		if %candle.visible:
			state = STATE.PLACED
		else:
			state = STATE.PICKED
	else: 
		labelVisibility = false
	
	if state == STATE.PLACED:
		%pickupLabel.visible = labelVisibility
	else:
		%pickupLabel.visible = false
	
