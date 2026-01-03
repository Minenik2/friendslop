extends Node

# mouse_manager, when something wants to show or hide the mouse
# it just calls on the mouse manager and it will do the check automatically.

var interactions = []

func show_mouse():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	interactions.append(true)
	
func hide_mouse():
	interactions.pop_back()
	if interactions.is_empty():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func try_hide_mouse():
	if interactions.is_empty():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
