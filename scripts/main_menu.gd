extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const PLAY = 0
const OPTIONS = 1
const QUIT = 2
var selected_option = 0


func _ready():
	set_process_input(true)

func _input(event):
	if (event.is_action_pressed("ui_up")):
		selected_option = (selected_option+2)%3
	elif (event.is_action_pressed("ui_down")):
		selected_option = (selected_option+1)%3
	elif (event.is_action_pressed("ui_accept")):
		select(selected_option)
	get_node("selected").set_pos(Vector2(304 , 304+(selected_option*32)))
	
func select(opt):
	if (opt == PLAY):
		get_tree().change_scene("res://scenes/Stage1.tscn")
	elif (opt == OPTIONS):
		pass
	elif (opt == QUIT):
		get_tree().quit()
