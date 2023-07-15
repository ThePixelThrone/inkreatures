extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var players = get_node("/root/global").player_list
	for player in players:
		if player.score == 3:
			player.win_count += 1
			get_node("player").player = player.number
			get_node("player").controller = "keyboard"
			var tex = load("res://assets/images/m_0"+var2str(player.monster)+"_"+player.color+".png")
			tex.set_flags(0)
			get_node("player/Sprite").set_texture(tex)
			get_node("player").set_color(player.color)
			get_node("player").connect("on_kill", self, "_on_player_kill")
			get_node("player").connect("on_death", self, "_on_player_death")
			get_node("player").set_physics_process(false)
			get_node("player").set_process(false)
	yield(get_tree().create_timer(5), "timeout")
	get_node("/root/global").reset_player_scores()
	get_tree().change_scene("res://CharacterSelection/CharacterSelection.tscn")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
