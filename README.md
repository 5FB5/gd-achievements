# gd-achievements
Achievement system plugin for Godot 3.x.x Engine

# How to install in your project?
## Copy from GitHub repository
Initially, the plugin is located in the "addons" folder. If your project does not have this folder, you can copy the plugin along with this folder into the project. If you have, copy only "gd-achievements" folder to your current "addons" folder in your project

# How to add custom achievements?
## 1. Generate JSON via Python script;
Open "achievements_generator.py". To make file, generator require to write main name of your achievement, short description and Godot's path to icon.

![example1](https://imgur.com/sMG1FGZ.png)

Easiest way to get path is pressing right mouse button to you icon and press "copy path".

![copy_path_example](https://imgur.com/kLXqxNx.png)

I recommend to store all icons to "resources/icons" folder from folder with addon ("addons/gd_achievements/resources/icons")

![icon_folder_example](https://imgur.com/uVvWaSb.png)

## 2. Place your new "achievements.json" to "addons/gd_achievements/resources/data" folder
As you can see, the structure of JSON file is simple and you can use fields like you want.

![json_example](https://imgur.com/fSVKCKj.png)

## 3. Open your Godot project, place "AchievementSystem" node to scene you want

![node_add_example](https://imgur.com/yOdOthY.png)

Also, you can change additional node's options from Inspector:
* "Show time" - How much time achievement's notficaton will shown in seconds;
* "Global Sound" - What sound will play for all achievements;
* "Global Sound Volume".

![node_example](https://imgur.com/kThTe6a.png)

As a result you'll see something like this

![ingame_example](https://imgur.com/24MtHit.png)


## Also
If you are developing the game and want to replay achievements, delete "achievements.json" in "GodotUserPath/<your_game>" folder
(check [data paths](https://docs.godotengine.org/ru/stable/tutorials/io/data_paths.html) for your OS) after each game started.

# I'll accept all problems and suggestions that you write in the repository on GitHub on "Issues" section
