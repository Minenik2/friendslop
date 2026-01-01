extends Node
class_name NetworkManager

@export var port: int = 7777
@export var max_players: int = 4
@export var player_scene: PackedScene

func _ready():
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)

func host_game():
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_server(port, max_players)

	if error != OK:
		push_error("Failed to host server")
		return

	multiplayer.multiplayer_peer = peer
	print("Hosting server")

	# Host always has peer_id = 1
	spawn_player(1)

func join_game(ip: String):
	var peer := ENetMultiplayerPeer.new()
	var error := peer.create_client(ip, port)

	if error != OK:
		push_error("Failed to join server")
		return

	multiplayer.multiplayer_peer = peer
	print("Joining server at ", ip)

func _on_peer_connected(peer_id: int):
	print("Peer connected:", peer_id)

	# ONLY the server spawns players
	if multiplayer.is_server():
		spawn_player(peer_id)
	
func _on_connected_to_server():
	print("Connected to server")

func _on_peer_disconnected(peer_id: int):
	print("Peer disconnected:", peer_id)

	var players = get_node("/root/main/world/players")
	var player = players.get_node_or_null(str(peer_id))
	if player:
		player.queue_free()

func _on_server_disconnected():
	print("Disconnected from server")

func _on_connection_failed():
	print("Connection failed")

func spawn_player(peer_id: int):
	var players = get_node("/root/main/world/players")

	var player = player_scene.instantiate()
	player.name = str(peer_id)

	# This is the MOST IMPORTANT LINE
	player.set_multiplayer_authority(peer_id)

	players.add_child(player)
