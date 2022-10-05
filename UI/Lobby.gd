extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	rpc_id(1, "start_matchmaking")



func _on_ReturnButton_pressed():
	rpc_id(1, "stop_matchmaking")
