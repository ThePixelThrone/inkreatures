extends Node

var p1_visible 
var p2_visible
var p3_visible
var p4_visible

var p1_count
var p2_count
var p3_count
var p4_count

var gameRootNode
var globals
var n_players

func _ready():
	gameRootNode = get_node("/root/GameRootNode")
	globals = get_node("/root/global")
	globals.setPlayerInputEnabled(false)
	n_players = globals.getNumberOfPlayers()
	print(n_players)
	for i in range(globals.MAX_PLAYERS):
		if i < n_players:
			setPlayerVisibility(i,true)
		else:
			setPlayerVisibility(i,false)

	var p1 = get_node("rootContainer/results/player1")
	var p2 = get_node("rootContainer/results/player2")
	var p3 = get_node("rootContainer/results/player3")
	var p4 = get_node("rootContainer/results/player4")
	
	p1.set_hidden(!p1_visible)
	p2.set_hidden(!p2_visible)
	p3.set_hidden(!p3_visible)
	p4.set_hidden(!p4_visible)

	#TODO: get score from stage.gd
	p1.get_node("count").set_text("0")
	p2.get_node("count").set_text("0")
	p3.get_node("count").set_text("0")
	p4.get_node("count").set_text("0")

func setPlayerVisibility(index,visibility):
	if index == 1:
		p1_visible = visibility
	elif index == 2:
		p2_visible = visibility
	elif index == 3:
		p3_visible = visibility
	elif index == 4:
		p4_visible = visibility
