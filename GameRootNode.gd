extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const splash_scene_path = "res://scenes/SplashScreen/Initial.tscn"
const menu_scene_path = "res://scenes/MainMenu/MainMenu.tscn"
const options_scene_path = "res://scenes/Options/Options.tscn"
const select_scene_path = "res://scenes/CharSelect/CharacterSelection.tscn"
const stage1_scene_path = "res://scenes/Stages/Stage1.tscn"
const stage2_scene_path = "res://scenes/Stages/Stage2.tscn"
const end_round_scene_path = "res://scenes/EndRound/end_round.tscn"
const end_game_scene_path = "res://scenes/EndGame/end_game.tscn"

var current_scene = null

var splash_scene
var menu_scene
var options_scene
var select_scene
var stage1_scene
var stage2_scene
var end_round_scene
var end_game_scene

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	splash_scene = preload(splash_scene_path)
	menu_scene = preload(menu_scene_path)
	options_scene = preload(options_scene_path)	
	select_scene = preload(select_scene_path)
	stage1_scene = preload(stage1_scene_path)
	stage2_scene = preload(stage2_scene_path)
	end_round_scene = preload(end_round_scene_path)
	end_game_scene = preload(end_game_scene_path)
	
	#Inicializar todas variaveis globais
	#load start screen
	set_process(true)
	
	
func _process(delta):
	if (current_scene == null):
		current_scene = splash_scene.instance()
		add_child(current_scene)
	#Processamento de Input ?
	

func showScene(scene):
	remove_child(current_scene)
	current_scene = scene
	add_child(current_scene)
	pass