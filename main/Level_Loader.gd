extends Node2D

class_name LevelLoader

var current_scene = null
@onready var loading_scene = preload('res://Loading/load_scene.tscn')
const LOBBY = "res://Levels/lobby.tscn"
const DINING_ROOM = "res://Levels/dining_room.tscn"
@onready var player = $"../Player2d/Player"


func _ready():
	load_lobby_scene(LOBBY)
	Game.door_entered_succesful.connect(_on_door_enter_successful)


func load_lobby_scene(next_scene):
	print("entered load lobby")
	ResourceLoader.load_threaded_request(next_scene)
	var scene_resource = ResourceLoader.load_threaded_get(next_scene)
	if(!scene_resource):
		print("scene resource null for some reason")
	var new_scene = scene_resource.instantiate()
	current_scene = next_scene
	print("new_scene created")
	add_child(new_scene)
	
func _on_door_enter_successful(next_scene, new_player_position):
	ResourceLoader.load_threaded_request(next_scene)
	get_child(0).queue_free()
	print("entering " + next_scene)
	var scene_resource = ResourceLoader.load(next_scene)
	
	if(!scene_resource):
		print("Scene resource null on_door_itneraction")
	var new_scene = scene_resource.instantiate()
	current_scene = next_scene
	Game.current_scene = current_scene
	player.position = new_player_position
	
	add_child(new_scene)
