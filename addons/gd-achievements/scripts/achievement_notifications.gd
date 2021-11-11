extends Control

# How long achievement will be shown (seconds)
export (float) var show_time = 4.7
export (float) var show_end_time = 1.5

# Global sound for all achievements
export var global_sound = preload("res://addons/gd-achievements/resources/sounds/achievement_earned.wav")

# -200 = mute, 
# -20 = default volume for notification ('cause basic sound is too loud), 
# 0 = original sound's volume
export var global_sound_volume = -20.0

enum GROW_DIRECTIONS {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}
enum POSITIONS {
	TOP_LEFT,
	TOP_RIGHT,
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
}
export (GROW_DIRECTIONS) var grow_direction = GROW_DIRECTIONS.DOWN
export (POSITIONS) var position = POSITIONS.TOP_LEFT

var achievement_count = 0
var sound_node = AudioStreamPlayer.new()

onready var achievement_notification = preload("res://gd-achievements/achievements_notification.tscn")

# Create audio node for playing sound
func init_sound_node():
	sound_node.set_stream(global_sound)
	sound_node.set_volume_db(global_sound_volume)
	add_child(sound_node)


func _ready():
	init_sound_node()
	AchievementManager.connect("achievement_unlocked", self, "create_achievement_panel")
	set_anchors_preset(PRESET_WIDE, false)
	margin_top = 0
	margin_bottom = 0
	margin_left = 0
	margin_right = 0


func create_achievement_panel(achievement):
	print("AchievementSystem: Show achievement '" + achievement["name"] + "'")

	var notification_instance = achievement_notification.instance()
	add_child(notification_instance)

	achievement_count += 1

	if achievement_count > 1:
		match grow_direction:
			GROW_DIRECTIONS.UP:
				notification_instance.rect_position.y = (1 - achievement_count) * (notification_instance.rect_size.y)
			GROW_DIRECTIONS.DOWN:
				notification_instance.rect_position.y = (achievement_count - 1) * (notification_instance.rect_size.y)
			GROW_DIRECTIONS.LEFT:
				notification_instance.rect_position.x = (1 - achievement_count) * (notification_instance.rect_size.x)
			GROW_DIRECTIONS.RIGHT:
				notification_instance.rect_position.x = (achievement_count - 1) * (notification_instance.rect_size.x)
	match position:
		POSITIONS.TOP_RIGHT:
			notification_instance.rect_position.x += rect_size.x - notification_instance.rect_size.x
		POSITIONS.BOTTOM_RIGHT:
			notification_instance.rect_position.x += rect_size.x - notification_instance.rect_size.x
			notification_instance.rect_position.y += rect_size.y - notification_instance.rect_size.y
		POSITIONS.BOTTOM_LEFT:
			notification_instance.rect_position.y += rect_size.y - notification_instance.rect_size.y

	notification_instance.set_achievement(achievement)

	sound_node.play()
	if notification_instance.has_method("on_show"):
		notification_instance.on_show()

	yield(notification_instance.get_tree().create_timer(show_time), "timeout")
	achievement_count -= 1

	if notification_instance.has_method("on_show"):
		notification_instance.on_hide()

	yield(get_tree().create_timer(show_end_time), "timeout")
	notification_instance.queue_free()
