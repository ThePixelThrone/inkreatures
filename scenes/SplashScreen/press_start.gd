extends Control

var gameRootNode

func _ready():
	set_process_input(true)
	gameRootNode = get_node("/root/GameRootNode")	
func _input(event):
	if (event.is_action("ui_accept")):
		gameRootNode.showScene(gameRootNode.menu_scene.instance())