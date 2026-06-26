extends Control

@onready var title_screen := load("res://scene/titleScreen/titleScreen.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	if(Game.currentRoute == "praise"):
		%fight.visible = false
		%praise.visible = true
	else:
		%fight.visible = true
		%praise.visible = false
		


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_button_pressed() -> void:
	print(title_screen)
	get_tree().change_scene_to_packed(title_screen)
	
func play_badge_sound():
	if(Game.currentRoute == "praise"):
		Audio.play("res://assets/sfx/win.ogg")
	else:
		Audio.play("res://assets/sfx/lose.ogg")
	$praise/VBoxContainer/HBoxContainer/continueButton.disabled = false
	$fight/VBoxContainer/HBoxContainer/continueButton.disabled = false
