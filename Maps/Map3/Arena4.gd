extends Node2D

onready var song = preload("res://Sounds/A Beautiful Song 8 bit .mp3")

func _ready():
	Global.node_creation_parent = self
	Global.canPlay = true
	$CanvasLayer/Label2.show()
	
	BackgroundSong.stopsong = true

func _process(delta):
	$CanvasLayer/Label2.text = "%d:%02d" % [floor($ArenaTimer.time_left / 60), int($ArenaTimer.time_left) % 60]


func _on_BossArea_body_entered(body):
	if body.name == "Player":
		$ArenaTimer.start()
		$BossDoor.global_position = $DoorPos.global_position
		$BossArea.queue_free()
		$CanvasLayer/Label2.show()
		print("sim")
		Global.bossFight = true
		BackgroundSong.change_song(song)
