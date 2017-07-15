extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_process_input(true)
	
func _input(event):
	if (event.is_action("ui_accept")):
		get_tree().change_scene("res://scenes/Main menu.tscn")