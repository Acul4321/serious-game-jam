extends Control

const MAINSCENE = preload("res://scene/main.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%Badge_fight.visible = Game.fightBadge
	%Badge_praise.visible = Game.praiseBadge

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAINSCENE)


func _on_quit_button_pressed() -> void:
	get_tree().quit()
