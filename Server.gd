extends Node

var player = preload("res://Player/Player.tscn")
var otherplayer = preload("res://Player/OtherPlayer.tscn")
var server_num
var connection = 0
var reconnect_count = 0

func _ready():
	get_tree().connect("connected_to_server", self, "_connected_to_server")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	get_tree().connect("connection_failed", self, "_connection_failed")

func join_server():
	#cria o cliente
	var client = NetworkedMultiplayerENet.new()
	var err = client.create_client("127.0.0.1", 4242)
	
	#verifica se criou, se não = para o processo
	if err != OK:
		print("Não foi possivel conectar ao server")
		return 
	get_tree().network_peer = client
	print(get_tree().network_peer)

func _connected_to_server():
	connection = 1
	print("Conectou ao servidor")

func _server_disconnected():
	connection = 0
	reconnect()
	print("Desconectou do servidor")

func _connection_failed():
	connection = 0
	reconnect()
	print("conexão falhou")

func reconnect():
	if reconnect_count >= 5:
		return
	else:
		join_server()
		reconnect_count += 1

remote func instance_player(id, location):
	if get_tree().get_network_unique_id() == 1:
		var p = player if get_tree().get_network_unique_id() == id else otherplayer
		var playerinstance = Global.instance_node(p, location, Global.node_creation_parent)
		playerinstance.name = str(id)
		if get_tree().get_network_unique_id() == id:
			for i in get_tree().get_network_connected_peers():
				if i != 1:
					instance_player(i, location)

func send_player_info():
	rpc_id(1, "get_player_info", Global.player_info)

func start_matchmaking():
	rpc_id(1, "start_matchmaking", get_tree().get_network_unique_id())

func stop_matchmaking():
	rpc_id(1, "stop_matchmaking", get_tree().get_network_unique_id())

remote func get_match_id(id):
	server_num = id


remote func start_game(point):
	Global.spawnpoint = point
	get_tree().change_scene("res://Maps/LobbyWorld.tscn")

remote func preconfig_game(map1, map2, map3):
	var arena1 = "res://Maps/Arena%s.tscn" %str(map1)
	var arena1_instance = load(arena1)
	var arena2 = "res://Maps/Arena%s.tscn" %str(map2)
	var arena2_instance = load(arena2)
	var arena3 = "res://Maps/Arena%s.tscn" %str(map3)
	var arena3_instance = load(arena3)
	
	
	
