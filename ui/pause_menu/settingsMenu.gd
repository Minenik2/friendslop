extends CanvasLayer

@onready var sensitivity_slider: HSlider = %SensitivitySlider
@onready var volume_slider: HSlider = %VolumeSlider
@onready var sensitivity_label: Label = %SensitivityLabel
@onready var volume_label: Label = %VolumeLabel

var menu_visible := false

# Define ranges
const MIN_SENSITIVITY := 0.001
const MAX_SENSITIVITY := 0.010
const DEFAULT_SENSITIVITY := 0.004

func _ready():
	# Configure slider ranges
	sensitivity_slider.min_value = MIN_SENSITIVITY
	sensitivity_slider.max_value = MAX_SENSITIVITY
	sensitivity_slider.step = 0.0001
	sensitivity_slider.value = GameSettingManager.mouse_sensitivity
	
	volume_slider.min_value = 0
	volume_slider.max_value = 100
	volume_slider.step = 1
	volume_slider.value = int(GameSettingManager.master_volume * 100.0)
	
	# Update labels
	_update_sensitivity_label(sensitivity_slider.value)
	_update_volume_label(volume_slider.value)
	
	# Connect signals
	sensitivity_slider.value_changed.connect(_on_sensitivity_changed)
	volume_slider.value_changed.connect(_on_volume_changed)
	
	# Start hidden
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("tabmenu"):
		_toggle_menu()

func _toggle_menu(playAudio: bool = true):
	if playAudio:
		AudioManager.playMenuClick()
	menu_visible = !menu_visible
	visible = menu_visible
	
	# Control mouse capture
	if menu_visible:
		MouseManager.show_mouse()
		UiManager.closeAllUi()
		UiManager.addUi(self)
	else:
		MouseManager.hide_mouse()
		UiManager.closeUi(self)

func _on_sensitivity_changed(value: float):
	GameSettingManager.set_mouse_sensitivity(value)
	_update_sensitivity_label(value)

func _on_volume_changed(value: float):
	GameSettingManager.set_master_volume(value / 100.0)
	_update_volume_label(value)

# Label updates
func _update_sensitivity_label(value: float):
	# Normalize so DEFAULT_SENSITIVITY shows as 1.0
	var normalized = value / DEFAULT_SENSITIVITY
	sensitivity_label.text = "Mouse Sensitivity: %.2f" % normalized

func _update_volume_label(value: float):
	volume_label.text = "Volume: %d%%" % int(value)


func _on_back_pressed() -> void:
	_toggle_menu()


func _on_inventory_pressed() -> void:
	_toggle_menu()

func _on_collection_pressed() -> void:
	_toggle_menu()


func _on_copy_pid_pressed() -> void:
	AudioManager.playMenuClick()
	MainMenu._on_copy_pid_pressed()
