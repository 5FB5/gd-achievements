extends Node

const ACHIEVEMENT_DATA_SCRIPT_ADDRESS = "res://achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION_ADDRESS = "res://achievements/resources/game_ui/ui_achievements_notification.tscn"

# How long achievement will be shown (seconds)
const ACHIEVEMENT_SHOW_TIME = 4.7

var m_achievements = {}

var achievementsDataScript = null
var achievementUiNotification = null

signal showAchievement(index)

func _init():
	achievementsDataScript = load(ACHIEVEMENT_DATA_SCRIPT_ADDRESS).new()
	# Getting all achievement's data
	m_achievements = achievementsDataScript.getAchievements()
	pass

func activateAchievement(achievementIndex):
	if (achievementIndex <= len(m_achievements.keys()) - 1):
		achievementUiNotification = preload(ACHIEVEMENT_UI_NOTIFICATION_ADDRESS).instance()
		add_child(achievementUiNotification)
	
		# Set name
		achievementUiNotification.get_node("achievementPanel/achievementDescription/description").text = m_achievements.keys()[int(achievementIndex)]
		# Set icon path
		achievementUiNotification.get_node("achievementPanel/achievementIcon/TextureRect").texture = load(m_achievements.values()[int(achievementIndex)]['icon_path'])
		achievementUiNotification.add_to_group("ui_achievement")
	
		# Play animation
		achievementUiNotification.get_node("AudioStreamPlayer").play()
		achievementUiNotification.get_node("AnimationPlayer").play("popup")
		# Wait a few seconds
		yield(get_tree().create_timer(ACHIEVEMENT_SHOW_TIME), "timeout")
		# Play hide animation
		achievementUiNotification.get_node("AnimationPlayer").play("hide")
		# Delete node
		yield(get_tree().create_timer(3), "timeout")
		achievementUiNotification.queue_free()
	else:
		print("Code Error: Attempt to read an achievement under a key index that is out of range (", achievementIndex, " of ", len(m_achievements.keys()) - 1, ")")
	
	pass
	
func _on_root_showAchievement(index):
	activateAchievement(index)
	pass
