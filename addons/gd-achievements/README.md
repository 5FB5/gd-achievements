# Plugin structure
## Main
- ```gd_achievements.gd```: Main plugin script that loads basic nodes and other data.

---

## Frontend

- ```gd-achievements/achievements_notification.tscn```: <b>Scene with default achievement's notification UI design that you can change</b>

<b></b>
- ```gd-achievements/achievements_notification.gd```: <b>Provides main functions for achievement UI node:</b>
    - ```set_achievement(achievement)```: <b>Sets the data from achievement json object such as name and icon</b>;
    - ```on_show()```: <b>Calls a popup animation for an achievement notification</b> 
    - ```on_hide()```: <b>Calls a hide animation after showing a notification</b> 

---

## Backend

- ```scripts/achievements_manager.gd```: 

<b>Manager's script. He does all work with reading and updating achievement's data. The main concept is that we put generated</b> ```.json``` <b>file inside the game as reference and his duplicate on user's device that we update after we get any achievement. If game rebooted it will check hash code both of files. In case they are different, Manager will update data from user's device file to game. This will prevent repeated notification calls from happening. On getting achievement it will send </b>```achievement_unlocked``` <b>signal to </b> 
```achievement_notification.gd``` <b>script with data about it.</b>

<b></b>
- ```scripts/achievements_notification.gd```: 

<b>Executes logic for achievement displaying and provides editor's settings. On calling an achievement it will execute functions that described in </b> ```achievements_notification.gd``` <b>script (see Frontend section).</b>


---

## AchievementManager API

<b>All methods can be called from the </b> `AchievementManager` <b>singleton:</b>

- `progress_achievement(key, progress)` - Set progress value for an achievement
- `unlock_achievement(key)` - Unlock an achievement and call notification

- `get_all_achievements()` - Returns a dictionary (indexed by key) of all the achievements you have in the game
- `get_achievement(key)` - Returns the full dictionary of your achievement. the mandatory data an achievement has is:

  - `key: String` - The key of your achievement (same as the one you used to get the achievement)
  - `name: String` - The name of your achievement
  - `goal: int` - The maximum progress of your achievement, at which point it'll be marked as achieved (only for progress achievements)
  - `current_progress: int` - The current progress of your achievement (only for progress achievements)
  - `icon_path: String` - The path of the icon that shows up in the achievement notification
  - `achieved: bool` - Wether or not the achievement is complete

- `reset_achievements()` - debug function, resets all received achievements by setting "achieved" field to 0 for all achievements.
