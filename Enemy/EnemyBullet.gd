extends Area2D


var velocity = Vector2(1, 0)
var speed = 250

func setRotation():
	pass

func _process(delta):
	global_position += velocity.rotated(rotation) * speed * delta

func _on_VisibilityNotifier2D_screen_exited():
	self.queue_free()


func _on_EnemyBullet_area_entered(area):
	if area.is_in_group("Enemy_damager"):
		area.queue_free()
		self.queue_free()
