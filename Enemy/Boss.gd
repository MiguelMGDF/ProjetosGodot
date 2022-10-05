extends KinematicBody2D

var rng = RandomNumberGenerator.new()
var iscd = false

onready var bullet = preload("res://Enemy/EnemyBullet.tscn")
onready var sound = preload("res://Sounds/SFX.tscn")
onready var sfx1 = preload("res://Sounds/GetHit.mp3")
onready var sfx2 = preload("res://Sounds/GetHit2.mp3")
onready var sfx3 = preload("res://Sounds/EnemyDeath.mp3")

var life = 50

func _ready():
	pass # Replace with function body.

func _process(delta):
	if Global.bossFight == true:
		$Sprites.rotation += 0.01
		if iscd == false:
			shoot()

func shoot():
	if !iscd and Global.node_creation_parent != null and Global.bossFight == true:
		Global.instance_enemy_bullet(bullet, $Sprites/Weapon/W1.global_position, Global.node_creation_parent, ($Sprites.rotation_degrees + 90))
		Global.instance_enemy_bullet(bullet, $Sprites/Weapon2/W2.global_position, Global.node_creation_parent,  ($Sprites.rotation_degrees + 0))
		Global.instance_enemy_bullet(bullet, $Sprites/Weapon3/W3.global_position, Global.node_creation_parent,  ($Sprites.rotation_degrees + 180))
		Global.instance_enemy_bullet(bullet, $Sprites/Weapon4/W4.global_position, Global.node_creation_parent,  ($Sprites.rotation_degrees + 270))
		iscd = true
		$WeaponCD.start()


func _on_Hitbox_area_entered(area):
	if Global.canPlay and Global.bossFight == true:
		if area.is_in_group("Enemy_damager"):
			area.queue_free()
			if life <= 0:
				deathsound()
				queue_free()
			else:
				hurtsound()
				life -= 1

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


func _on_WeaponCD_timeout():
	iscd = false
