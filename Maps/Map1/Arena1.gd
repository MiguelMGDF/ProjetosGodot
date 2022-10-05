extends Node2D

onready var scene = preload("res://Maps/Arena2.tscn")
onready var song = preload("res://Sounds/Song of the Ancients 8 bit.mp3")

func _ready():
	$ReadyTimer.start()
	Global.node_creation_parent = self
	BackgroundSong.change_song(song)
	Server.rpc_id(0, "instance_a_player", get_tree().get_network_unique_id())

#func _exit_tree():
#	Global.node_creation_parent = null

func _process(delta):
	$CanvasLayer/Label.text = "%d:%02d" % [floor($ReadyTimer.time_left / 60), int($ReadyTimer.time_left) % 60]
	$CanvasLayer/Label2.text = "%d:%02d" % [floor($ArenaTimer.time_left / 60), int($ArenaTimer.time_left) % 60]
#	$CanvasLayer/Label.text = str($ReadyTimer.get_time_left())
#	$CanvasLayer/Label2.text = str($ArenaTimer.get_time_left())

func _on_ReadyTimer_timeout():
	$CanvasLayer/ColorRect.hide()
	$CanvasLayer/Label.hide()
#	$ArenaTimer.start()
	$CanvasLayer/Label2.show()
	Global.canPlay = true


func _on_ArenaTimer_timeout():
	var arena = scene.instance()
	get_tree().get_root().add_child(arena)
	self.queue_free()
