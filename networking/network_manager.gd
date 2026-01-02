extends Node

@onready var noray_component: norayNetworkComponent = $norayComponent

# ===============================
# STATE
# ===============================
var is_host : bool = false
var external_oid : String = ""

# ===============================
# PUBLIC API
# ===============================

func start_host():
	is_host = true
	
	noray_component.setup_network()
	await noray_component.create_server_peer()

func join_game(host_oid : String):
	is_host = false
	external_oid = host_oid
	
	print("Joining host OID:", host_oid)
	noray_component.setup_network()
	noray_component.create_client_peer()

func returnNorayComponent():
	return $norayComponent
