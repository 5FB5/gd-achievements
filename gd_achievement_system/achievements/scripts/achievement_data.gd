extends Node

# You can change this path
const achievementsDataFileDefaultAddress = "res://achievements/data/achievements.json"

# You must create or add in current singleton script dictionary that stores achievements data
onready var globalAchievements = get_node("/root/Global").globalAchievements

func getAchievements():
	var file = File.new()
	file.open(achievementsDataFileDefaultAddress, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	return data
	pass

