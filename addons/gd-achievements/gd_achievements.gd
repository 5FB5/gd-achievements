# Main addon script, that loads nodes we need
tool

extends EditorPlugin

const ACHIEVEMENT_MAIN_SCRIPT_PATH = "res://addons/gd-achievements/scripts/achievement_manager.gd"

func _enter_tree():
	add_custom_type("AchievementSystem", "Control", load(ACHIEVEMENT_MAIN_SCRIPT_PATH), preload("icon.png"))
	print("AchievementSystem: Initialized!")
	pass

func _exit_tree():
	remove_custom_type("AchievementSystem")
	remove_custom_type("AchievementSystem: Uninitialized")
	pass
