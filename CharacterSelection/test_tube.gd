extends Node2D

const TOTAL_MONSTERS = 5

var colors
var selected_color = 0
var selected_monster = 1

var animator
var mon_animator

func join(joined):
	if (joined):
		get_node("PlayerLabel").show()
		animator.play("Select_"+colors[selected_color])
		mon_animator.play(colors[selected_color]+var2str(selected_monster))
	else:
		get_node("PlayerLabel").hide()
		animator.play("Jump_to_join")
		mon_animator.play("vanish")

func set_ready(ready):
	if (ready):
		animator.play("Ready_"+colors[selected_color])
	else:
		animator.play("Select_"+colors[selected_color])

func next_color():
	selected_color = (selected_color+1)%colors.size()
	animator.play("Select_"+colors[selected_color])
	mon_animator.play(colors[selected_color]+var2str(selected_monster))

func prev_color():
	selected_color = (selected_color-1+colors.size())%colors.size()
	animator.play("Select_"+colors[selected_color])
	mon_animator.play(colors[selected_color]+var2str(selected_monster))

func next_mon():
	selected_monster = (selected_monster%TOTAL_MONSTERS)+1
	mon_animator.play(colors[selected_color]+var2str(selected_monster))

func prev_mon():
	selected_monster = ((selected_monster-2+TOTAL_MONSTERS)%(TOTAL_MONSTERS))+1
	mon_animator.play(colors[selected_color]+var2str(selected_monster))

func _ready():
	colors = get_node("/root/global").colors
	animator = get_node("TubeAnimation")
	mon_animator = get_node("MonAnimation")
