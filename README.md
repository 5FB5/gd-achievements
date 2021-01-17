# gd-achievements
Simple achievement system template for Godot Engine ver. 3+ projects

# How to install in your project?
By default you must take "achievements" folder and copy it to project's root folder. In Godot destination must be like "res://achievements/..."

# How it works?
* Generate your JSON file via "achievements_generator.py" script. It accepts name of achievement, description, path to icons(by default I've created achievement/resources/icons folder and you can use it)
![example1](https://i.imgur.com/n05Mxpl.png)

* Place achievements.json that created by script to "achievements/data" folder (if you want to change file's destination, you must check and change paths in achievement_data.gd and achievement_manager.gd)

* Open your Godot project

* Place "ui_achievements_main.tscn" from "achievements/resources/game_ui" into scene you need.

* To activate achievement UI notification window, just call " emit_signal("showAchievement", <array's index of achievement>) " from node.
For example, I've spawned all 3 achievements from file that I generated
![example2](https://i.imgur.com/R5eTN0z.png)

As a result you'll see something like this
![example3](https://i.imgur.com/HKMcwmJ.png)

I'll accept all problems and suggestions that you write in the repository on GitHub on "Issues" section
