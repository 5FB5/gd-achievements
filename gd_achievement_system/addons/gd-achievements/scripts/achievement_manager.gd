tool

extends Control

const ACHIEVEMENT_DATA_SCRIPT_ADDRESS = "res://addons/gd-achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION_ADDRESS = "res://addons/gd-achievements/resources/game_ui/achievements_notification.tscn"
const ACHIEVEMENT_SHOW_END_TIME = 1.5

# How long achievement will be shown (seconds)
export var SHOW_TIME = 4.7
# Global sound for all achievements
export var globalSound = preload("res://addons/gd-achievements/resources/sounds/achievement_earned.wav")
# -200 = mute, -20 = default volume for notification ('cause basic sound is too loud), 0 = original sound's volume
export var globalSoundVolume = -20.0

# Main array with achievements
var m_achievements = {}

var achievementCount = 0
var achievementCurrentPosY = 0

var achievementsDataScript = null
var achievementUiNotificationInstance = null

var soundNode = AudioStreamPlayer.new()

# Main call signal that accepts index of an achievement from array
signal showAchievement(index)

func _init():
	achievementsDataScript = load(ACHIEVEMENT_DATA_SCRIPT_ADDRESS).new()
	# Getting all achievement's data
	m_achievements = achievementsDataScript.getAchievements()
	pass

func _ready():
	# Spawn AudioStreamPlayer node
	initSoundNode()
	
	connect("showAchievement", self, "activateAchievement")
	pass

# Create audio node for playing sound
func initSoundNode():
	soundNode.set_stream(globalSound)
	soundNode.set_volume_db(globalSoundVolume)
	add_child(soundNode)
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
		achievementUiNotification.add_to_group("ui_achievement")
		
		# Increase count of UI instances for correct position
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
		# Play sound
		soundNode.play()
		# Play animation
		achievementUiNotification.get_node("AnimationPlayer").play("popup")
		
		# Wait a few seconds
		yield(achievementUiNotification.get_tree().create_timer(SHOW_TIME), "timeout")
		achievementCount -= 1
		
		# Play hide animation
		achievementUiNotification.get_node("AnimationPlayer").play("hide")
		
		# Delete node
		yield(get_tree().create_timer(ACHIEVEMENT_SHOW_END_TIME), "timeout")
		achievementUiNotification.queue_free()

	else:
		print("Error: Attempt to read an achievement from array under a key index that is out of range (", 
				achievementIndex, " of ", len(m_achievements.keys()) - 1, ")")
	
	pass
