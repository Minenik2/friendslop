extends Control

func setup(character: CharacterStats):
	$VBoxContainer/Label.text = character.character_name
	$VBoxContainer/TextureProgressBar.max_value = character.max_hp
	$VBoxContainer/TextureProgressBar.value = character.current_hp

func playerSetup(character: CharacterStats, currentHP, currentMaxHP):
	$VBoxContainer/Label.text = character.character_name
	$VBoxContainer/TextureProgressBar.max_value = currentHP
	$VBoxContainer/TextureProgressBar.value = currentMaxHP
