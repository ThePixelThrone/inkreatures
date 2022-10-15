extends Node2D

var total_monsters

var colors
var selected_color = 0
var selected_monster = 1

var animator
var mon_sprite

func join(joined):
	if (joined):
		get_node("PlayerLabel").show()
		animator.play("Select_"+colors[selected_color])
		update_textures()
		mon_sprite.show()
	else:
		get_node("PlayerLabel").hide()
		animator.play("Jump_to_join")
		mon_sprite.hide()

func set_ready(ready):
	if (ready):
		animator.play("Ready_"+colors[selected_color])
	else:
		animator.play("Select_"+colors[selected_color])

func next_color():
	selected_color = (selected_color+1)%colors.size()
	animator.play("Select_"+colors[selected_color])
	update_textures()

func prev_color():
	selected_color = (selected_color-1+colors.size())%colors.size()
	animator.play("Select_"+colors[selected_color])
	update_textures()

func get_selected_color():
	return colors[selected_color]

func next_mon():
	selected_monster = (selected_monster%total_monsters)+1
	update_textures()

func prev_mon():
	selected_monster = ((selected_monster-2+total_monsters)%(total_monsters))+1
	update_textures()

func update_textures():
	var mon_number = var2str(selected_monster)
	var mon_tex = load("res://assets/images/m_0"+mon_number+"_"+colors[selected_color]+".png")
	mon_sprite.set_texture(mon_tex)

func _ready():
	colors = get_node("/root/global").colors
	total_monsters = get_node("/root/global").TOTAL_MONSTERS
	mon_sprite = get_node("Tube/Mon")
	animator = get_node("Animator")
	mon_sprite.hide()
