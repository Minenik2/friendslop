extends Node

# Default values
var mouse_sensitivity: float = 0.004
var master_volume: float = 1.0

func set_mouse_sensitivity(value: float):
	mouse_sensitivity = value

func set_master_volume(value: float):
	master_volume = value
	# Update audio bus immediately
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))

func linear_to_db(value: float) -> float:
	if value <= 0.0:
		return -80.0 # practically silent
	return 20.0 * log(value) / log(10.0)
