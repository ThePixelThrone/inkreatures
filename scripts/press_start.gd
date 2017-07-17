extends Control

func _ready():
	set_process(true)
	set_process_input(true)

func _process(delta):
	if (not get_node("VideoPlayer").is_playing()):
			get_node("VideoPlayer").stop()
			get_node("VideoPlayer").hide()
			get_node("background").show()

func _input(event):
	if (event.is_action_pressed("ui_accept")):
		if (get_node("VideoPlayer").is_playing()):
			get_node("VideoPlayer").stop()
			get_node("VideoPlayer").hide()
			get_node("background").show()
		else:
			get_tree().change_scene("res://scenes/MainMenu.tscn")