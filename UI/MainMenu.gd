extends Control

onready var title = $Menu/Title
onready var http = $HTTPRequest
var info_sent := false

func _ready():
	
	$Cores/Control/GridContainer/Brown.modulate = Color.brown
	$Cores/Control/GridContainer/Blue.modulate = Color.blue
	$Cores/Control/GridContainer/White.modulate = Color.white
	$Cores/Control/GridContainer/Black.modulate = Color.crimson
	$Cores/Control/GridContainer/Yellow.modulate = Color.yellow
	$Cores/Control/GridContainer/Cyan.modulate = Color.cyan
	$Cores/Control/GridContainer/Green.modulate = Color.green
	$Cores/Control/GridContainer/Grass.modulate = Color.darkgreen
	$Cores/Control/GridContainer/Purple.modulate = Color.purple
	
	BackgroundSong.stopsong = true
	$Menu.show()
	$Cores.hide()
	$Login.hide()
	if !Global.newPlayer:
		Firebase.get_document("users/" + Firebase.user_info.id, http)
		info_sent = false 
	elif Global.newPlayer:
		Firebase.save_document("users?documentId=" + Firebase.user_info.id, Global.player_info, http)
		info_sent = true 
	else: 
		show_error("Error Firebase")
	
	print("ready")



func _on_Offline_button_down():
	$Menu.hide()
	$Cores.show()


func _on_Brown_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Brown.modulate
	Global.playercolor = $Cores/Control/GridContainer/Brown.modulate


func _on_Blue_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Blue.modulate
	Global.playercolor = $Cores/Control/GridContainer/Blue.modulate


func _on_White_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/White.modulate
	Global.playercolor = $Cores/Control/GridContainer/White.modulate


func _on_Black_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Black.modulate
	Global.playercolor = $Cores/Control/GridContainer/Black.modulate


func _on_Yellow_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Yellow.modulate
	Global.playercolor = $Cores/Control/GridContainer/Yellow.modulate


func _on_Cyan_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Cyan.modulate
	Global.playercolor = $Cores/Control/GridContainer/Cyan.modulate


func _on_Green_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Green.modulate
	Global.playercolor = $Cores/Control/GridContainer/Green.modulate


func _on_Grass_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Grass.modulate
	Global.playercolor = $Cores/Control/GridContainer/Grass.modulate


func _on_Purple_pressed():
	$Cores/Control/Player.modulate = $Cores/Control/GridContainer/Purple.modulate
	Global.playercolor = $Cores/Control/GridContainer/Purple.modulate

func _on_Login_pressed():
	$Login/Control/ColorRect/Errortxt.text = ""
	$Login/Control/Login.disabled = true
	$Login/Control/Register.disabled = true
	Server.join_server()
	#goTest()

func _on_Register_pressed():
	$Login/Control/ColorRect/Errortxt.text = ""
	$Login/Control/Login.disabled = true
	$Login/Control/Register.disabled = true
	Server.join_server()
	#goTest()

func goTest():
	$Login.hide()
	$Menu.show()


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print(response_code)
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary 
	match response_code:
		404:
			print("erro firestore")
		200:
			if info_sent:
				show_error("Info Saved")
				info_sent = false
			Global.player_info = result_body.fields
			Server.send_player_info()
			$Cores/NameLabel.text = str(Global.player_info.nickname.stringValue)
			changePoints()

func show_error(error_text):
	$NotificationError.dialog_text = error_text
	$NotificationError.popup_centered_clamped()
	$AnimationPlayer.play("Popup")
	$NotificationError.show()

func _on_PlayButton_pressed():
	$Cores.hide()
	$Waiting.show()
	Server.start_matchmaking()

func changePoints():
	var points = str(Global.player_info.rankedpoints.integerValue)
	$Cores/PointsLbl.text = "RankedPoints:\n%s" %points 

func _on_ReturnButton_pressed():
	$Cores.show()
	$Waiting.hide()
	Server.stop_matchmaking()
