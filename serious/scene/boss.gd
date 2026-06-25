extends Node3D

@export var rotation_speed : int = 2
@onready var battle: Node3D = $".."

@onready var model: Node3D = $Torus
var hit_tween: Tween

@onready var material := model.get_active_material(0).duplicate() as StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# for flicker
	model.set_surface_override_material(0, material)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(!battle.battle_paused):
		rotation.y += rotation_speed * delta
	else:
		rotation.lerp(Vector3i(0,0,0),1.0)
		
func hit() -> void:
	if hit_tween:
		hit_tween.kill()

	model.scale = Vector3.ONE
	material.albedo_color = Color(2.0, 0, 0)

	hit_tween = create_tween()

	hit_tween.tween_property(model, "scale", Vector3(1.2, 0.8, 1.2), 0.05)

	for i in range(3):
		hit_tween.tween_callback(func(): material.albedo_color = Color(2.0, 2.0, 2.0))
		hit_tween.tween_interval(0.03)
		hit_tween.tween_callback(func(): material.albedo_color = Color.WHITE)
		hit_tween.tween_interval(0.03)

	hit_tween.parallel().tween_property(model, "scale", Vector3.ONE, 0.12)

	hit_tween.finished.connect(func():
		model.scale = Vector3.ONE
		material.albedo_color = Color.WHITE
	)
