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

onready var globalAchievements = get_node("/root/Global").achievements

var achievementCount = 0
var achievementCurrentPosY = 0
var achievementsDataScript = null
var achievementUiNotificationInstance = null
var soundNode = AudioStreamPlayer.new()

# Main call signal that accepts index of an achievement from array
signal showAchievement(index)

# Create audio node for playing sound
func initSoundNode():
	soundNode.set_stream(globalSound)
	soundNode.set_volume_db(globalSoundVolume)
	add_child(soundNode)
	pass

func rewriteAchievementsDataToUserJson():
	var userFileJson = File.new()
	if (userFileJson.file_exists(ACHIEVEMENT_JSON_USER_PATH)):
		userFileJson.open(ACHIEVEMENT_JSON_USER_PATH, File.WRITE)
		userFileJson.store_string(to_json(globalAchievements))
		userFileJson.close()
		pass
	else:
		print("Achievement System Error: Can't open achievements data. It doesn't exists on device")
		return
	pass

func updateReferenceJson(achievementsFromUserFileBuf):
	if (globalAchievements.hash() != achievementsFromUserFileBuf.hash()):
			print("AchievementSystem: User's file and reference file are different. Updating data...")
			globalAchievements = achievementsFromUserFileBuf
			print("AchievementSystem: Data updated!")
			pass
	pass

func updateJsonOnDeviceBeforeClosing():
	var userFile = File.new()
	if (userFile.file_exists(ACHIEVEMENT_JSON_USER_PATH) and globalAchievements != null):
		userFile.open(ACHIEVEMENT_JSON_USER_PATH, File.WRITE)
		userFile.store_string(to_json(globalAchievements))
		userFile.close()
	print("AchievementSystem: updateJsonOnDeviceBeforeClosing()")
	pass

func checkJsonOnDevice():
	print("AchievementSystem: Checking 'achievements.json' file on device...")
	var jsonUserFile = File.new()
	if (not jsonUserFile.file_exists(ACHIEVEMENT_JSON_USER_PATH)):
		print("AchievementSystem: 'achievements.json' not found on device. Creating...")
		jsonUserFile.open(ACHIEVEMENT_JSON_USER_PATH, File.WRITE)
		jsonUserFile.store_line(to_json(globalAchievements))
		jsonUserFile.close()
		print("AchievementSystem: File created!")
		pass
	else:
		print("AchievementSystem:'achievements.json' is exists on device!")
		jsonUserFile.open(ACHIEVEMENT_JSON_USER_PATH, File.READ)
		
		print("AchievementSystem: Getting data from file...")
		var achievementsFromUserFileBuf = parse_json(jsonUserFile.get_as_text())
		jsonUserFile.close()
		
		if (achievementsFromUserFileBuf != null):
			updateReferenceJson(achievementsFromUserFileBuf)
			pass
		else:
			print("AchievementSystem Error: achievementsFromUserFileBuf is NULL")
			return
		pass
	pass

func _notification(what):
	if (what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST):
		updateJsonOnDeviceBeforeClosing()
		pass
	pass

func getFieldName(index):
	return(str(globalAchievements.keys()[index]))
	pass
	
func getFieldDescription(index):
	return(str(globalAchievements.values()[index]['description']))
	pass
	
func getFieldProgress(index):
	return(int(globalAchievements.values()[index]['progress']))
	pass
	
func getFieldIsSecret(index):
	var isSecret = int(globalAchievements.values()[index]['is_secret'])
	if (isSecret == 0):
		return false
	elif (isSecret == 1):
		return true
	pass
	
func getFieldIconPath(index):
	return(str(globalAchievements.values()[index]['icon_path']))
	pass
	
func getFieldIsHave(index):
	var isHave = int(globalAchievements.values()[index]['is_have'])
	if (isHave == 0):
		return false
	elif (isHave == 1):
		return true
	pass	

func resetAchievementNotifications():
	for i in range((len(globalAchievements.keys()))):
		globalAchievements.values()[i]["is_have"] = 0
		pass
	rewriteAchievementsDataToUserJson()
	print("AchievementSystem: resetAchievementsNotifications()")
	pass

func _ready():
	achievementsDataScript = load(ACHIEVEMENT_DATA_SCRIPT_PATH).new()
	globalAchievements = achievementsDataScript.getAchievements()
	initSoundNode()
	checkJsonOnDevice()
	connect("showAchievement", self, "activateAchievement")
	pass
	

func createAchievementPanel(achievementIndex):
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
	achievementUiNotification.get_node("achievementPanel/achievementDescription/description").text = globalAchievements.keys()[int(achievementIndex)]
		
	# Set icon path
	achievementUiNotification.get_node("achievementPanel/achievementIcon/TextureRect").texture = load(
		globalAchievements.values()[int(achievementIndex)]['icon_path']
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

func activateAchievement(achievementIndex):
	if (achievementIndex > (len(globalAchievements.keys()) - 1) or achievementIndex < 0):
		print("AchievementSystem Error: Attempt to get an achievement on " + achievementIndex + 
			" index that is out of range (" + (len(globalAchievements.keys()) - 1) + ")")
		return
	
	var currentAchievementIsHaveField = int(globalAchievements.values()[achievementIndex]["is_have"])

	if ((achievementCount >= 0) and (achievementCount <= len(globalAchievements.keys()) - 1) and currentAchievementIsHaveField == 0):
		print("AchievementSystem: Show achievement '" + str(globalAchievements.keys()[achievementIndex]) + "', index = " + str(achievementIndex))
		globalAchievements.values()[achievementIndex]["is_have"] = 1
		rewriteAchievementsDataToUserJson()
		
		createAchievementPanel(achievementIndex)		
	pass
