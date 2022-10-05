extends KinematicBody2D

var speed = 150
var velocity := Vector2()
var bulletcd = 0.3
var iscd = false
var life = 10
var rng = RandomNumberGenerator.new()

onready var sfx1 = preload("res://Sounds/GetHit.mp3")
onready var sfx2 = preload("res://Sounds/GetHit2.mp3")
onready var sound = preload("res://Sounds/SFX.tscn")
onready var sound1 = preload("res://Sounds/Shooting.mp3")
onready var bullet = preload("res://Player/Bullet.tscn")
onready var sfx3 = preload("res://Sounds/PlayerDeath.mp3")


func _ready():
	Global.player = self
	$CanvasLayer/PlayerName.text = Global.playerName
	setcolor()
	if Global.mobile:
		$CanvasLayer/VirtualJoystick.show()
		$CanvasLayer/VirtualJoystick2.show()
		
	pass

func _exit_tree():
	Global.player = null

func _process(delta):
	if Global.canPlay:
		if !Global.mobile:
			velocity.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
			velocity.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
			
			$Camera2D.offset_h = (get_global_mouse_position().x - global_position.x) / (1920.0/2.0)
			$Camera2D.offset_v = (get_global_mouse_position().y - global_position.y) / (1080.0/2.0)
			
			velocity = velocity.normalized()

			global_position += speed * velocity * delta
			
			if Input.is_action_pressed("shoot"):
				shoot()
			
			if Input.is_action_pressed("quit"):
				get_tree().quit()
			
		move_and_slide(velocity * speed)
		look_at(get_global_mouse_position())

func _on_VirtualJoystick_analogic_chage(move):
	if Global.canPlay:
		velocity = move


func _on_VirtualJoystick2_analogic_chage(move):
	if Global.canPlay: 
		shoot()

func shoot():
	if !iscd and Global.node_creation_parent != null:
		Global.instance_node(bullet, $Weapon/Position2D.global_position, Global.node_creation_parent)
		$bulletcd.start(bulletcd)
		var sfx = sound.instance()
		get_parent().add_child(sfx)
		sfx.sfx = sound1
		sfx.global_position = self.global_position
		sfx.volume_db = -10
		sfx.playsfx()
		iscd = true
	else:
		pass



func setcolor():
	if Global.playercolor != null:
		$Sprite.modulate = Color(Global.playercolor)

func _on_bulletcd_timeout():
	iscd = false

func _on_Area2D_area_entered(area):
	if Global.canPlay:
		if area.is_in_group("PlayerDamager"):
			area.queue_free()
			if life <= 1:
				$CanvasLayer/LifeBar.value -= 10
				death()
			else:
				hurtsound()
				life -= 1
				$CanvasLayer/LifeBar.value -= 10
		elif area.is_in_group("PlayerDamager2"):
			
			if life <= 1:
				$CanvasLayer/LifeBar.value -= 10
				death()
			else:
				hurtsound()
				life -= 1
				$CanvasLayer/LifeBar.value -= 10

func death():
	var sfx = sound.instance()
	get_parent().add_child(sfx)
	sfx.sfx = sfx3
	sfx.global_position = self.global_position
	sfx.volume_db = 15
	sfx.playsfx()
	Global.canPlay = false
	$DeathScreen/ColorRect.show()

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


func _on_Button_pressed():
	var menu = Global.mainMenu.instance()
	get_tree().get_root().add_child(menu)
	get_parent().queue_free()


func _on_SyncPlayer_timeout():
	Server.rpc_unreliable_id(0, "update_transform", global_position, rotation_degrees, velocity)
