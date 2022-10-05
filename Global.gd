extends Node

var mobile = false
var node_creation_parent = null
var player = null
var playercolor = null
var canPlay = false
var playerName = ""
var mainMenu = load("res://MainMenu.tscn")
var bossFight = false
var newPlayer = false
var server_num
var spawnpoint

var player_info := {
	"nickname": {},
	"rankedpoints": {},
	"lastColor": {},
} setget set_player_info

var players_on_match := {
	
}

func _ready():
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		mobile = true

func instance_node(node, location, parent):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	return node_instance

func instance_enemy_bullet(node, location, parent, rotation):
	var node_instance = node.instance()
	parent.add_child(node_instance)
	node_instance.global_position = location
	node_instance.rotation_degrees = rotation
	return node_instance

func set_player_info(value: Dictionary) -> void:
	player_info = value



remote func preconfig_game(map1, map2, map3):
	if get_tree().get_network_unique_id() == 1:
		pass
