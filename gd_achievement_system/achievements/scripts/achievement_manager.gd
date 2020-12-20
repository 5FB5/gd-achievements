extends Node

const ACHIEVEMENT_DATA_SCRIPT_ADDRESS = "res://achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION_ADDRESS = "res://achievements/resources/game_ui/ui_achievements_notification.tscn"

var m_achievements = {}

var achievementsData = null
var achievementUiNotification = null

func _init():
	achievementsData = load(ACHIEVEMENT_DATA_SCRIPT_ADDRESS).new()
	achievementUiNotification = preload(ACHIEVEMENT_UI_NOTIFICATION_ADDRESS).instance()
	
	# Getting all achievement's data
	m_achievements = achievementsData.getAchievements()
	
	# Test, must be in loop func
	achievementUiNotification.get_node("achievementPanel/achievementIcon/TextureRect").texture = load(m_achievements.values()[0]['icon_path'])
	achievementUiNotification.get_node("achievementPanel/achievementDescription/description").text = m_achievements.keys()[0]
	achievementUiNotification.get_node("AnimationPlayer").play("popup")
	
	achievementUiNotification.add_to_group("achievementUi")
	add_child(achievementUiNotification)

	pass
	
func _process(delta):
	pass
