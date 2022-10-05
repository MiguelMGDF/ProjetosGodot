extends KinematicBody2D

var rng = RandomNumberGenerator.new()
var speed = 120
var velocity = Vector2()
var life = 2
var stun = false
onready var sound = preload("res://Sounds/SFX.tscn")
onready var sfx1 = preload("res://Sounds/GetHit.mp3")
onready var sfx2 = preload("res://Sounds/GetHit2.mp3")
onready var sfx3 = preload("res://Sounds/EnemyDeath.mp3")


func _process(delta):
	if Global.canPlay:
		if Global.player != null and stun == false:
			velocity = global_position.direction_to(Global.player.global_position)
		elif stun:
			velocity = lerp(velocity, Vector2(0, 0), 0.3)
		global_position += velocity * speed * delta


func _on_Hitbox_area_entered(area):
	if Global.canPlay:
		if area.is_in_group("Enemy_damager"):
			area.queue_free()
			modulate = Color.brown
			velocity = -velocity*3
			$StunTimer.start()
			stun = true
			if life <= 0:
				deathsound()
				queue_free()
			else:
				hurtsound()
				life -= 1


func _on_StunTimer_timeout():
	stun = false
	modulate = Color("6e6e6e")

func hurtsound():
	rng.randomize()
	var rnd = rng.randi_range(1, 2)
	print(rnd)
	if rnd == 1:
		var sfx = sound.instance()
		get_parent().add_child(sfx)
		sfx.sfx = sfx1
		sfx.global_position = self.global_position
		sfx.playsfx()
	elif rnd == 2:
		var sfx = sound.instance()
		get_parent().add_child(sfx)
		sfx.sfx = sfx2
		sfx.global_position = self.global_position
		sfx.playsfx()

func deathsound():
	var sfx = sound.instance()
	get_parent().add_child(sfx)
	sfx.sfx = sfx3
	sfx.global_position = self.global_position
	sfx.volume_db = 15
	sfx.playsfx()
