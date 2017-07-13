extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_process_input(true)

func _input(event):
	# <<Player 1 input handling>>
	if (event.is_action_pressed("p1_up")):
		pass
	elif (event.is_action_pressed("p1_down")):
		pass
	elif (event.is_action_pressed("p1_left")):
		pass
	elif (event.is_action_pressed("p1_right")):
		pass
	elif (event.is_action_pressed("p1_jump") || event.is_action_pressed("p1_start")):
		pass
	elif (event.is_action_pressed("p1_cancel")):
		pass
	