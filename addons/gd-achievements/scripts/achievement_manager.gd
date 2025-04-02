extends Node

const ACHIEVEMENT_JSON_USER_PATH = "user://achievements.json"
const ACHIEVEMENT_JSON_REFERENCE_PATH = "res://gd-achievements/achievements.json"

var achievements = {}
var achievementCount = 0

signal achievement_unlocked(achievement)

func _ready():
	achievements = read_achievements_from_file()
	check_json_on_device()


func progress_achievement(key, progress):
	print("AchievementSystem: progress achievement(" + key + ", " + String.num(progress) + ")")
	achievements[key]["current_progress"] = min(
		progress + achievements[key]["current_progress"], achievements[key]["goal"]
	)
	if achievements[key]["current_progress"] >= achievements[key]["goal"]:
		activate_achievement(key)


func unlock_achievement(key):
	print("AchievementSystem: unlock_achievement(" + key + ")")
	activate_achievement(key)


func get_achievement(key):
	return achievements[key]

func get_all_achievements():
	return achievements

func read_achievements_from_file():
	var file = FileAccess.open(ACHIEVEMENT_JSON_REFERENCE_PATH, FileAccess.READ)
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	for key in data.keys():
		data[key]["key"] = key
	file.close()

	return data

func parse_to_json(original_data):
	var data = original_data
	for key in data.keys():
		data[key].erase("key") # do not include the "key" property in the json
	return JSON.new().stringify(data)

func parse_from_file(file):
	var test_json_conv = JSON.new()
	test_json_conv.parse(file.get_as_text())
	var data = test_json_conv.get_data()
	for key in data.keys():
		data[key]["key"] = key # add the "key" property to the final dict
	return data

func reset_achievements():
	for key in achievements:
		achievements[key]["achieved"] = false
	rewrite_achievements_data_to_user_json()
	print("AchievementSystem: reset_achievements()")


func rewrite_achievements_data_to_user_json():
	if FileAccess.file_exists(ACHIEVEMENT_JSON_USER_PATH):
		var userFileJson = FileAccess.open(ACHIEVEMENT_JSON_USER_PATH, FileAccess.WRITE)
		userFileJson.store_string(parse_to_json(achievements))
		userFileJson.close()
	else:
		print("Achievement System Error: Can't open achievements data. It doesn't exists on device")
		return


func update_reference_json(achievements_from_user_file_buf):
	if not achievements or achievements.hash() != achievements_from_user_file_buf.hash():
		print("AchievementSystem: User's file and reference file are different. Updating data...")
		achievements = achievements_from_user_file_buf
		print("AchievementSystem: Data updated!")


func update_json_on_device_before_closing():
	if FileAccess.file_exists(ACHIEVEMENT_JSON_USER_PATH) and achievements != null:
		var userFile = FileAccess.open(ACHIEVEMENT_JSON_USER_PATH, FileAccess.WRITE)
		userFile.store_string(parse_to_json(achievements))
		userFile.close()
	print("AchievementSystem: update_json_on_device_before_closing()")


func check_json_on_device():
	print("AchievementSystem: Checking 'achievements.json' file on device...")
	var json_user_file
	if not FileAccess.file_exists(ACHIEVEMENT_JSON_USER_PATH):
		print("AchievementSystem: 'achievements.json' not found on device. Creating...")
		json_user_file = FileAccess.open(ACHIEVEMENT_JSON_USER_PATH, FileAccess.WRITE)
		json_user_file.store_line(parse_to_json(achievements))
		json_user_file.close()
		print("AchievementSystem: File created!")
	else:
		print("AchievementSystem:'achievements.json' is exists on device!")
		json_user_file = FileAccess.open(ACHIEVEMENT_JSON_USER_PATH, FileAccess.READ)

		print("AchievementSystem: Getting data from file...")
		var achievements_from_user_file_buf = parse_from_file(json_user_file)
		json_user_file.close()

		if achievements_from_user_file_buf != null:
			update_reference_json(achievements_from_user_file_buf)
		else:
			print("AchievementSystem Error: achievements_from_user_file_buf is NULL")
			return


func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		update_json_on_device_before_closing()


func activate_achievement(key):
	if not achievements.has(key):
		print(
			(
				"AchievementSystem Error: Attempt to get an achievement on "
				+ key
				+ ", key doesn't exist."
			)
		)
		return

	var currentAchievement = achievements[key]

	if currentAchievement["achieved"] == false:
		achievements[key]["achieved"] = true
		rewrite_achievements_data_to_user_json()

		emit_signal("achievement_unlocked", currentAchievement)
