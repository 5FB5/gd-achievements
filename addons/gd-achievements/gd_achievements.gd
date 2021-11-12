# Main addon script, that loads nodes we need
tool

extends EditorPlugin

const ACHIEVEMENT_MAIN_SCRIPT_PATH = "res://addons/gd-achievements/scripts/achievement_notifications.gd"
const GLOBAL_SCRIPT_PATH = "res://addons/gd-achievements/scripts/achievement_manager.gd"


func _enter_tree():
	add_custom_type(
		"AchievementNotifications", "Control", load(ACHIEVEMENT_MAIN_SCRIPT_PATH), preload("icon.png")
	)
	add_autoload_singleton("AchievementManager", GLOBAL_SCRIPT_PATH)
	print("AchievementSystem: Initialized!")
	pass


func _exit_tree():
	remove_custom_type("AchievementNotifications")
	remove_autoload_singleton("AchievementManager")
	print("AchievementSystem: Uninitialized")
	pass
