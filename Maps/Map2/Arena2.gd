extends Node2D

onready var scene = preload("res://Maps/Arena4.tscn")

func _ready():
	Global.node_creation_parent = self
	Global.canPlay = true
	$CanvasLayer/Label2.show()
	$ArenaTimer.start()

#func _exit_tree():
#	Global.node_creation_parent = null

func _process(delta):
	$CanvasLayer/Label2.text = "%d:%02d" % [floor($ArenaTimer.time_left / 60), int($ArenaTimer.time_left) % 60]




func _on_ArenaTimer_timeout():
	var arena = scene.instance()
	get_tree().get_root().add_child(arena)
	self.queue_free()
