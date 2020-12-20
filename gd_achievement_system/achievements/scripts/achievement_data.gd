extends Node

const achievementsDataFileDefaultAddress = "res://achievements/data/achievements.json"

# You must create or add in current singleton script dictionary that stores achievements data
onready var achievements = get_node("/root/Global").achievements

func getAchievements():
	var file = File.new()
	file.open(achievementsDataFileDefaultAddress, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	return data
	pass

func _init():
	achievements = getAchievements()
	
	# test
	for achievementName in achievements:
		print(achievementName + " : " + achievements[achievementName]['description'])
