extends RichTextLabel

export (float, 0.1, 1.0) var hue = 0.0

func _ready():
	pass

#func _physics_process(delta):
#	modulate = Color.from_hsv(hue, 1.0, 1.0, 1.0)
#	if hue < 1.0:
#		hue += 0.007
#	else:
#		hue = 0.0
