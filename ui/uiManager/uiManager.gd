extends Node

# UIManager, when something wants to show an ui
# it just call on the ui manager and it will add it to the UI stack
# this makes it easier to check if other ui is running when specific ui
# buttons are pressed. And also with closeAllUi() you can close all shown uis
# before showing a new one

var uiArray = []

func addUi(uiObj):
	uiArray.append(uiObj)

func closeUi(uiObj):
	uiArray.erase(uiObj)

func closeAllUi():
	for ui in uiArray:
		uiArray.pop_back()._toggle_menu(false)
		#uiArray.pop_back().hide()
