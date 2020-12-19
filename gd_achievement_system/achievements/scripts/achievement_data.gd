extends Node

const achievementsDataFileDefaultAddress = "res://achievements/data/achievements.json"

var achievementsData = {}

func getAchievements():
	var file = File.new()
	file.open(achievementsDataFileDefaultAddress, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	return data
	pass

func _init():
	achievementsData = getAchievements()

	for achievementName in achievementsData:
		print(achievementName)
