extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const splash_scene_path = "res://scenes/SplashScreen/Initial.tscn"
const menu_scene_path = "res://scenes/MainMenu/MainMenu.tscn"
const options_scene_path = "res://scenes/"
const select_scene_path = "res://scenes/CharSelect/CharacterSelection.tscn"
const stage1_scene_path = "res://scenes/Stages/Stage1.tscn"
const stage2_scene_path = "res://scenes/Stages/Stage2.tscn"
const end_round_scene_path = "res://scenes/"
const end_game_scene_path = "res://scenes/"

var current_scene = null

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	var splash_scene = preload(splash_scene_path)
	var menu_scene = preload(menu_scene_path)
	#var options_scene = preload(options_scene_path)	
	var select_scene = preload(select_scene_path)
	var stage1_scene = preload(stage1_scene_path)
	var stage2_scene = preload(stage2_scene_path)
	#var end_round_scene = preload(end_round_scene_path)
	#var end_game_scene = preload(end_game_scene_path)
	
	#Inicializar todas variaveis globais
	#load start screen
	set_process(true)
	
	
func _process(delta):
	#Processamento de Input ?
	pass

func showScene(scene):
	pass