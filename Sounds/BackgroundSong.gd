extends AudioStreamPlayer

var stopsong = false

func _ready():
	pass # Replace with function body.

func change_song(song):
	self.stream = song
	self.volume_db = -20
	self.play()

func _process(delta):
	if stopsong:
		if volume_db >= -100:
			volume_db -= 1
		else:
			stopsong = false
			self.stop()
