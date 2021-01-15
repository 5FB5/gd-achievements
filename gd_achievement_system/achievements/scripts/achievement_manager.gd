extends Node

const ACHIEVEMENT_DATA_SCRIPT_ADDRESS = "res://achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION_ADDRESS = "res://achievements/resources/game_ui/ui_achievements_notification.tscn"

# How long achievement will be shown (seconds)
export var ACHIEVEMENT_SHOW_TIME = 4.7

var ACHIEVEMENT_SHOW_END_TIME = 3.5

var m_achievements = {}

var achievementCount = 0;
var achievementCurrentPosY = 0

var achievementsDataScript = null
var achievementUiNotificationInstance = null

# Main call signal that accepts index of an achievement from array
signal showAchievement(index)

func _init():
	achievementsDataScript = load(ACHIEVEMENT_DATA_SCRIPT_ADDRESS).new()
	# Getting all achievement's data
	m_achievements = achievementsDataScript.getAchievements()
	pass

func activateAchievement(achievementIndex):
	if ((achievementCount >= 0) and (achievementCount <= len(m_achievements.keys()) - 1) and (achievementIndex <= len(m_achievements.keys()) - 1)):
		# Preload instance of scene
		achievementUiNotificationInstance = preload(ACHIEVEMENT_UI_NOTIFICATION_ADDRESS).instance()
		# Get ID for a new instance
		var achievementUiNotificationId = achievementUiNotificationInstance.get_instance_id()
		# Create instance with unique ID for independent working with its own nodes
		var achievementUiNotification = instance_from_id(achievementUiNotificationId)
		add_child(achievementUiNotification)
		
		# Increase count of UI instance for correct position
		achievementCount += 1 
		
		# Change position of current instance's animation if it more than 1 notification window
		if (achievementCount > 1):
			achievementUiNotification.rect_position.y = achievementCurrentPosY + 130
			achievementCurrentPosY = achievementUiNotification.rect_position.y
			pass
		
		# Set name
		achievementUiNotification.get_node("achievementPanel/achievementDescription/description").text = m_achievements.keys()[int(achievementIndex)]
		# Set icon path
		achievementUiNotification.get_node("achievementPanel/achievementIcon/TextureRect").texture = load(m_achievements.values()[int(achievementIndex)]['icon_path'])
		achievementUiNotification.add_to_group("ui_achievement")
	
		# Play sound
		achievementUiNotification.get_node("AudioStreamPlayer").play()
		# Play animation
		achievementUiNotification.get_node("AnimationPlayer").play("popup")
		# Wait a few seconds
		yield(achievementUiNotification.get_tree().create_timer(ACHIEVEMENT_SHOW_TIME), "timeout")
		# Play hide animation
		achievementUiNotification.get_node("AnimationPlayer").play("hide")
		achievementCount -= 1
		# Delete node
		yield(get_tree().create_timer(ACHIEVEMENT_SHOW_END_TIME), "timeout")
		achievementUiNotification.queue_free()

	else:
		print("Code Error: Attempt to read an achievement from array under a key index that is out of range (", achievementIndex, " of ", len(m_achievements.keys()) - 1, ")")
	
	pass
	
func _on_root_showAchievement(index):
	activateAchievement(index)
	pass
