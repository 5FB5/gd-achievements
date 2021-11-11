extends Control


func _ready():
	AchievementManager.reset_achievements()
	AchievementManager.unlock_achievement("my_instant_achievement")
	yield(get_tree().create_timer(1), 'timeout')
	AchievementManager.progress_achievement("my_progress_achievement", 5)
