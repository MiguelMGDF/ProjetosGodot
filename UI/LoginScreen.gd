extends Control

onready var http : HTTPRequest = $HTTPRequest
onready var username = $Background/Register/Panel/Control/VBoxContainer/Usernametxt2
onready var loginreg = $Background/Register/Panel/Control/VBoxContainer/Logintxt
onready var loginlog = $Background/Login/Panel/Control/VBoxContainer/Logintxt
onready var passreg = $Background/Register/Panel/Control/VBoxContainer/Passtxt
onready var passlog = $Background/Login/Panel/Control/VBoxContainer/Passtxt
onready var httpFirestore = $FirestoreHttp


var info_sent := false

func _ready():
	$Background/Login.hide()
	$Background/Register.hide()
	$Background/JoinServer.show()
	get_tree().connect("connected_to_server", self, "_connected")

func _connected():
	$Background/Login.show()
	$Background/Register.hide()
	$Background/JoinServer.hide()

func _on_ToRegister_pressed():
	$Background/Login.hide()
	$Background/Register.show()


func _on_ToLogin_pressed():
	$Background/Login.show()
	$Background/Register.hide()


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var responseBody := JSON.parse(body.get_string_from_ascii())
	if response_code != 200:
		show_error(responseBody.result.error.message.capitalize())
	else:
		show_error("Done!")
		yield(get_tree().create_timer(2.0), "timeout")
		get_tree().change_scene("res://UI/MainMenu.tscn")


func _on_Login_pressed():
	if  passlog.text.empty() or loginlog.text.empty():
		show_error("Preencha todos os campos")
	else:
		Global.newPlayer = false
		Firebase.login(loginlog.text, passlog.text, http)
		

func _on_Register_pressed():
	if  username.text.empty() or passreg.text.empty() or loginreg.text.empty():
		show_error("Preencha todos os campos")
	else: 
		Firebase.register(username.text, loginreg.text, passreg.text, http)
		Global.player_info.nickname = {"stringValue": username.text}
		Global.player_info.rankedpoints = {"integerValue": 0}
		Global.player_info.lastColor = {"stringValue": "white"}

func show_error(error_text):
	$NotificationError.dialog_text = error_text
	$NotificationError.popup_centered_clamped()
	$AnimationPlayer.play("Popup")
	$NotificationError.show()


func _on_FirestoreHttp_request_completed(result, response_code, headers, body):
	var result_body := JSON.parse(body.get_string_from_ascii()).result as Dictionary 
	match response_code:
		404:
			show_error("Error!!")
			return
		200:
			if info_sent:
				show_error("Info Saved")
				info_sent = false
				return
			Global.player_info = result_body.fields


func _on_JoinButton_pressed():
	Server.join_server()
