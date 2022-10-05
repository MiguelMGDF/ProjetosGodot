extends Node

const API_KEY := "null"
const PROJECT_ID := "null"

const REGISTER_URL := "null" + API_KEY
const LOGIN_URL := "null" + API_KEY
const FIRESTORE_URL := "null"+ PROJECT_ID +"null"

var user_info := {}

func _get_user_info(result: Array) -> Dictionary:
	var result_body := JSON.parse(result[3].get_string_from_ascii()).result as Dictionary
	return {
		"token": result_body.idToken,
		"id": result_body.localId
		}

func _get_request_headers() -> PoolStringArray:
	return PoolStringArray([
		"Content-Type: aplication/json",
		"Authorization: Bearer %s" %user_info.token
	])

func register(username: String, email: String, password: String, http: HTTPRequest) -> void:
	var body := {
		"username": username,
		"email": email,
		"password": password,
	}
	http.request(REGISTER_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)
		Global.newPlayer = true
	print(user_info)

func login(email: String, password: String, http: HTTPRequest):
	var body := {
		"email": email,
		"password": password,
		"returnSecureToken": true,
	}
	http.request(LOGIN_URL, [], false, HTTPClient.METHOD_POST, to_json(body))
	var result := yield(http, "request_completed") as Array
	if result[1] == 200:
		user_info = _get_user_info(result)
		Global.newPlayer = false
	print(result)

func save_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := {"fields": fields}
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_POST, body)

func get_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_GET)

func update_document(path: String, fields: Dictionary, http: HTTPRequest) -> void:
	var document := {"fields": fields}
	var body := to_json(document)
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_PATCH, body)

func delete_document(path: String, http: HTTPRequest) -> void:
	var url := FIRESTORE_URL + path
	http.request(url, _get_request_headers(), false, HTTPClient.METHOD_DELETE)
