extends Control


func set_achievement(achievement):
	get_node("achievementPanel/achievementDescription/description").text = achievement["name"]
	get_node("achievementPanel/achievementIcon/TextureRect").texture = load(achievement["icon_path"])


func on_show():
	get_node("AnimationPlayer").play("popup")


func on_hide():
	get_node("AnimationPlayer").play("hide")
