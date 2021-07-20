tool

extends Node

# You can change this path
const achievementsDataFileDefaultAddress = "res://addons/gd-achievements/resources/data/achievements.json"

func getAchievements():
	var file = File.new()
	file.open(achievementsDataFileDefaultAddress, File.READ)
	var data = parse_json(file.get_as_text())
	file.close()
	
	return data
	pass
