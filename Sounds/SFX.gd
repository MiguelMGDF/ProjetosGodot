extends AudioStreamPlayer2D

var sfx = null

func playsfx():
	self.stream = sfx
	self.play()

func _on_SFX_finished():
	self.queue_free()
