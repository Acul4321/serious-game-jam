extends CharacterBody3D

enum STATE {HELD, EMPTY}
var currentState : STATE = STATE.EMPTY
var currentCandle

#from Kenny assets: https://github.com/KenneyNL/Starter-Kit-3D-Platformer/blob/main/scripts/player.gd

@export_subgroup("Components")
@export var view: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

@onready var spin_timer: Timer = $SpinTimer
var accumulated_rotation := 0.0
var previous_yaw := 0.0

#@onready var particles_trail = $ParticlesTrail
#@onready var sound_footsteps = $SoundFootsteps
@onready var model = $model
@onready var animation = $model/AnimationPlayer

# Functions
func _ready() -> void:
	previous_yaw = rotation.y

func _physics_process(delta):

	# Handle functions
	
	handle_spinning(delta)

	handle_controls(delta)
	handle_gravity(delta)

	handle_effects(delta)

	# Movement

	var applied_velocity: Vector3

	applied_velocity = velocity.lerp(movement_velocity, delta * 10)
	applied_velocity.y = -gravity

	velocity = applied_velocity
	move_and_slide()

	# Rotation

	if Vector2(velocity.z, velocity.x).length() > 0:
		rotation_direction = Vector2(velocity.z, velocity.x).angle()

	rotation.y = lerp_angle(rotation.y, rotation_direction, delta * 10)

	# Falling/respawning

	if position.y < -17:
		death()

	# Animation for scale (jumping and landing)

	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * 10)

	# Animation when landing

	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		#Audio.play("res://sounds/land.ogg")

	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects(delta):

	#particles_trail.emitting = false
	#sound_footsteps.stream_paused = true
	
	if currentState == STATE.HELD:
		%candle.visible = true
	else:
		%candle.visible = false
		
	if is_on_floor():
		var horizontal_velocity = Vector2(velocity.x, velocity.z)
		var speed_factor = horizontal_velocity.length() / movement_speed / delta
		if speed_factor > 0.05:
			if animation.current_animation != "walking_animation":
				animation.play("walking_animation", 0.1)

			#if speed_factor > 0.3:
				##sound_footsteps.stream_paused = false
				##sound_footsteps.pitch_scale = speed_factor
#
			#if speed_factor > 0.75:
				#particles_trail.emitting = true

		#idle
		elif animation.current_animation != "praise_up_animation" && animation.is_playing():
			animation.play("praise_up_animation", 0.1, 0.8)
			
			
		if animation.current_animation == "walking_animation":
			animation.speed_scale = speed_factor
		else:
			animation.speed_scale = 1.0
			
	# jump
	elif animation.current_animation != "praise_up_animation":
		animation.play("praise_up_animation", 0.1)

# Handle movement input

func handle_controls(delta):

	# Movement

	var input := Vector3.ZERO

	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")

	input = input.rotated(Vector3.UP, view.rotation.y)

	if input.length() > 1:
		input = input.normalized()

	movement_velocity = input * movement_speed * delta

	# Jumping

	if Input.is_action_just_pressed("jump"):

		if jump_single or jump_double:
			jump()

# Handle gravity

func handle_gravity(delta):

	gravity += 25 * delta

	if gravity > 0 and is_on_floor():

		jump_single = true
		gravity = 0

# Jumping

func jump():

	#Audio.play("res://sounds/jump.ogg")

	gravity = -jump_strength

	model.scale = Vector3(0.5, 1.5, 0.5)

	if jump_single:
		jump_single = false;
		jump_double = true;
	else:
		jump_double = false;

func handle_spinning(delta):
	var current_yaw = rotation.y
	
	var delta_yaw = wrapf(
		current_yaw - previous_yaw,
		-PI,
		PI
	)
	accumulated_rotation += delta_yaw
	previous_yaw = current_yaw
	if abs(accumulated_rotation) >= TAU:
		on_full_spin()
		accumulated_rotation = 0.0

func on_full_spin():
	print("spin complete")
	spin_timer.stop()
	spin_timer.start()

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	animation.pause()


func death() -> void:
	print("die")
	spin_timer.start()
	global_position = Vector3i(0,1,0)
	if(currentState == STATE.HELD):
		currentCandle.visible = true
		currentCandle = null
		currentState = STATE.EMPTY
