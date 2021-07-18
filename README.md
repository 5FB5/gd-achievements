# gd-achievements
Simple achievement system template for Godot Engine ver. 3+ projects

# How to install in your project?
## Copy from GitHub repository
Initially, the plugin is located in the "addons" folder. If your project does not have this folder, you can copy the plugin along with this folder into the project. If you have, copy only "gd-achievements" folder to your current "addons" folder in your project

# How it works?
* Generate/modify your JSON file via "achievements_generator.py" script. It accepts name of achievement, description, path to icons(by default I've created achievement/resources/icons folder and you can use it)
![example1](https://i.imgur.com/n05Mxpl.png)

* Place achievements.json that created by script to "achievements/data" folder (if you want to change file's destination, you must check and change paths in achievement_data.gd and achievement_manager.gd)

* Structure of JSON file included: main achievement's name, inside it we have description of achievement, *"is_secret"* field that means is your achievement is secret (use it how you want, for me I want to use it with GameJolt API), maximum progress value that you can use for comparison between current game's data and achievement's data, "icon_path" that stores path to icon in Godot's project. You can use the *"is_have"* field to check and store information about whether a player has already received a particular achievement. For example, when player completed task, game can check current state of achievement with field from file and rewrite *json* file, denoting that the player received it.

![file_example](https://i.imgur.com/7hgEoWW.png)

# Using it in your project

* Open your Godot project

* Place "ui_achievements_main.tscn" from "achievements/resources/game_ui" into scene you need.

* To activate achievement UI notification window, just call " emit_signal("showAchievement", <array's index of achievement>) " from node.
For example, I've spawned all 3 achievements from file that I generated

![example2](https://i.imgur.com/R5eTN0z.png)

As a result you'll see something like this

![example3](https://i.imgur.com/HKMcwmJ.png)

# Q/A
## Q: I've added it in my project, but I can't use "showAchievement" command.
**A:** Check that "ui_achievements_main.tscn" scene, that you add in your game level, have an "achievement_manager.gd" script and load it if it doesn't. Repeat it with "ui_achievements_notification.tscn" scene and add "achievement_data.gd" script.

## Q: I have "ERROR: Cannot load source code from file 'res://../achievements/scripts/achievement_manager.gd'". How to fix it?
**A:** Open "../achievement/resources/game_ui/ui_achievement_main.tscn" and add "achievement_manager.gd" in it.

# I'll accept all problems and suggestions that you write in the repository on GitHub on "Issues" section
