extends Node

const ACHIEVEMENT_DATA_SCRIPT = "res://achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION = "res://achievements/resources/game_ui/ui_achievements_notification.tscn"

onready var achievements = load(ACHIEVEMENT_DATA_SCRIPT).new()
onready var achievementUiNotification = preload(ACHIEVEMENT_UI_NOTIFICATION).instance()

func _init():
	pass
