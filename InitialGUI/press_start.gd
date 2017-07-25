extends Control

func _ready():
	set_process_input(true)
	
func _input(event):
	if (event.is_action("ui_accept")):
		get_tree().change_scene("res://InitialGUI/MainMenu.tscn")