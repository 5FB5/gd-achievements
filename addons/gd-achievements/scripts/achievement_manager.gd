tool

extends Control

const ACHIEVEMENT_DATA_SCRIPT_PATH = "res://addons/gd-achievements/scripts/achievement_data.gd"
const ACHIEVEMENT_UI_NOTIFICATION_PATH = "res://addons/gd-achievements/resources/game_ui/achievements_notification.tscn"
const ACHIEVEMENT_JSON_USER_PATH = "user://achievements.json"
const ACHIEVEMENT_JSON_REFERENCE_PATH = "res://addons/gd-achievements/resources/data/achievemenets.json"

# How long achievement will be shown (seconds)
export var SHOW_TIME = 4.7
const SHOW_END_TIME = 1.5

# Global sound for all achievements
export var globalSound = preload("res://addons/gd-achievements/resources/sounds/achievement_earned.wav")

# -200 = mute, 
# -20 = default volume for notification ('cause basic sound is too loud), 
# 0 = original sound's volume
export var globalSoundVolume = -20.0

var m_achievements = {} # Main array with achievements
var achievementCount = 0
var achievementCurrentPosY = 0
var achievementsDataScript = null
var achievementUiNotificationInstance = null
var soundNode = AudioStreamPlayer.new()

# Main call signal that accepts index of an achievement from array
signal showAchievement(index)

func _init():
	achievementsDataScript = load(ACHIEVEMENT_DATA_SCRIPT_PATH).new()
	# Get all achievement's data
	m_achievements = achievementsDataScript.getAchievements()
	pass

# Create audio node for playing sound
func initSoundNode():
	soundNode.set_stream(globalSound)
	soundNode.set_volume_db(globalSoundVolume)
	add_child(soundNode)
	pass

func updateReferenceJson(achievementsFromUserFileBuf):
	if (m_achievements.hash() != achievementsFromUserFileBuf.hash()):
			print("AchievementSystem: User file and reference file are different. Updating data...")
			m_achievements = achievementsFromUserFileBuf
			print("AchievementSystem: Data updated!")
			pass
	pass

func updateUserJson():
	var userFile = File.new()
	userFile.open(ACHIEVEMENT_JSON_USER_PATH, File.WRITE)
	userFile.store_string(to_json(m_achievements))
	userFile.close()
	pass

func checkFileJsonOnDevice():
	var jsonUserFile = File.new()
	
	if (not jsonUserFile.file_exists(ACHIEVEMENT_JSON_USER_PATH)):
		print("AchievementSystem: 'achievements.json' not found on device. Creating...")
		jsonUserFile.open(ACHIEVEMENT_JSON_USER_PATH, File.WRITE)
		jsonUserFile.store_line(to_json(m_achievements))
		jsonUserFile.close()
		print("AchievementSystem: File created!")
		pass
	else:
		jsonUserFile.open(ACHIEVEMENT_JSON_USER_PATH, File.READ)
		var achievementsFromUserFileBuf = parse_json(jsonUserFile.get_as_text())
		jsonUserFile.close()
		
		updateReferenceJson(achievementsFromUserFileBuf)
		pass
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		updateUserJson()
		pass
	pass

func _ready():
	initSoundNode()
	checkFileJsonOnDevice()
	# Bind main signal to function
	connect("showAchievement", self, "activateAchievement")
	pass
	
func getFieldName(index):
	var name = m_achievements.keys()[index]
	return name
	pass
	
func getFieldDescription(index):
	var desc = m_achievements.values()[index]['description']
	return desc
	pass
	
func getFieldProgress(index):
	var progress = m_achievements.values()[index]['progress']
	return(int(progress))
	pass
	
func getFieldIsSecret(index):
	var isSecret = m_achievements.values()[index]['is_secret']
	if (int(isSecret) == 0):
		return false
	elif (int(isSecret) == 1):
		return true
	pass
	
func getFieldIconPath(index):
	var path = m_achievements.values()[index]['icon_path']
	return(str(path))
	pass
	
func getFieldIsHave(index):
	var isHave = m_achievements.values()[index]['is_have']
	if (int(isHave) == 0):
		return false
	elif (int(isHave) == 1):
		return true
	pass	
	
func activateAchievement(achievementIndex):
	if (achievementIndex > len(m_achievements.keys()) - 1):
		print("AchievementSystem Error: Attempt to get an achievement on " + achievementIndex + 
			" index that is out of range (" + (len(m_achievements.keys()) - 1) + ")")
		return

	if ((achievementCount >= 0) and (achievementCount <= len(m_achievements.keys()) - 1) and (m_achievements.values()[achievementIndex]["is_have"] == 0)):
		m_achievements.values()[achievementIndex]["is_have"] = 1
		# Preload instance of scene
		achievementUiNotificationInstance = preload(ACHIEVEMENT_UI_NOTIFICATION_PATH).instance()
		# Get ID for a new instance
		var achievementUiNotificationId = achievementUiNotificationInstance.get_instance_id()
		# Create instance with unique ID for independent working with its own nodes
		var achievementUiNotification = instance_from_id(achievementUiNotificationId)
		add_child(achievementUiNotification)
		
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
		achievementUiNotification.get_node("achievementPanel/achievementIcon/TextureRect").texture = load(
			m_achievements.values()[int(achievementIndex)]['icon_path']
			)
		
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
		yield(get_tree().create_timer(SHOW_END_TIME), "timeout")
		achievementUiNotification.queue_free()	
	pass
