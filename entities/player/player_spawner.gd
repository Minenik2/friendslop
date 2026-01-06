extends Node3D

@export var player_scene : PackedScene
var players := {}

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	MainMenu.hostPressed.connect(_on_host_pressed)

func _on_host_pressed():
	print("spawning host player")
	_spawn_player(1)
	MouseManager.try_hide_mouse()

func _on_peer_connected(peer_id : int):
	if not multiplayer.is_server():
		return
	print("spawning player peer id: %s" % peer_id)
	_spawn_player(peer_id)

func _spawn_player(peer_id : int):
	var player := player_scene.instantiate()
	# connect spawn player signal
	player.get_node("playerDeathComponent").connect("respawn", _on_killzone_respawn)
	player.player_id = peer_id
	player.name = "Player_%d" % peer_id
	player.set_multiplayer_authority(peer_id)

	add_child(player)
	players[peer_id] = player

	print("Spawned player for peer:", peer_id)

func _on_peer_disconnected(peer_id : int):
	if players.has(peer_id):
		players[peer_id].queue_free()
		players.erase(peer_id)


func _on_killzone_respawn(body: playerMain) -> void:
	body.position = position
