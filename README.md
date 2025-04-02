# gd-achievements

<p align="center"> <img src="https://imgur.com/vIftQvp.png"/></p>
<b><p align="center">Achievement System Plugin for Godot Engine 4.4.1 </p></b>

# How to install in your project?

## Copy from GitHub repository

The main part of the plugin is located in `addons/gd-achievements`. Copy this folder to your `addons` folder within your project (or, if you don't have an `addons` folder, copy it from here). You will also want to include the `gd-achievements` folder on the root of the project. It includes the `notification` scene and sample `achievements.json` which you may want to edit yourself.

After that don't forget to enable it in "Project Settings -> Plugins"

It should be done automatically, but ensure that "addons\gd-achievements\scripts\achievements_manager.gd" **is added as a singleton/autoload**

(Project -> Project Settings -> AutoLoad -> <path_to_achievements_manager.gd> -> Add)

## Download from Godot Asset Library

Find this plugin and install it like you want (from editor directly or from website). Remember to install **BOTH** the `addons/gd-achievements` and the `gd-achievements` folders.

https://godotengine.org/asset-library/asset/1004

# How to add custom achievements?

## 1. Generate JSON via Python script;

Open "achievements_generator.py". To make file, generator require to write main name of your achievement, short description and Godot's path to icon.

![example1](https://imgur.com/O4wqhHP.png)

Easiest way to get path is pressing right mouse button to you icon and press "copy path".

![copy_path_example](https://imgur.com/kLXqxNx.png)

Icon size must be: 150x150px

![icon_folder_example](https://imgur.com/uVvWaSb.png)

## 2. Place your new "achievements.json" in the "res://gd_achievements" folder

As you can see, the structure of JSON file is simple and you can use fields like you want.

![json_example](https://imgur.com/WGwuDZ3.png)

The mandatory default fields are:

- `name: String` - The name of your achievement
- `goal: int` - The maximum progress of your achievement, at which point it'll be marked as achieved (only for progress achievements)
- `current_progress: int` - The current progress of your achievement. (only for progress achievements. in your file, it should always be set to 0)
- `icon_path: String` - The path of the icon that shows up in the achievement notification
- `achieved: bool` - Wether or not the achievement is complete

You can add or remove the others to your liking.

## 3. Open your Godot project, place "AchievementNotifications" node to scene you want

![node_add_example](https://imgur.com/UQnBXmU.png)

Also, you can change additional node's options from Inspector:

- `Show Time` - How much time achievement's notficaton will shown in seconds;
- `Show End Time` - Time between when the end animation starts playing and when the AchievementSystem will delete the notification node;
- `Global Sound` - What sound will play for all achievements;
- `Global Sound Volume`.
- `Grow direction` (Up, Down, Left, Right) - The relative position where other achievements will show up if more than one would appear at the same time
- `Position` (Top Left, Bottom Left, Top Right, Bottom Right) - The position on the screen where your achievements will start appearing

![node_example](https://imgur.com/ToTLIMN.png)

To get the achievements, you will need to call the singleton `AchievementManager`. There are two functions you can use, depending on the type of achievement you're handling.

- `progress_achievement(key, progress)` - If your achievement has a progression number (i.e., die 100 times), you can call this function with the amount you want to add to the progress. It checks the `current_progress` of an achievement against it's `goal`, if it's higher, it will trigger the notification and mark your achievement as `achieved: true`
- `unlock_achievement(key)` - Instantly unlocks an achievement (if it's not already unlocked) and triggers the notification

<b>More about plugin and API you can read in</b> ```addons/gd_achievements``` <b>folder</b>

![code](https://imgur.com/sMhvf6T.png)

As a result you'll see something like this

![ingame_example](https://imgur.com/24MtHit.png)

# Customize Notifications

If you want to customize your notifications, you can create your own to replace the default one. You can modify the one in `gd-achievements/achievements_notification.tscn` or create a new one with the same name.
The AchievementSystem will automatically call the following methods on your custom notification, so it must include them in a script on the root node:

- `set_achievement(achievement)` - This function will pass the achievement data when the notification is triggered. This way you can programatically set the name, icon, or whatever custom property you have added to the notification.
- `on_show()` - This function will be called when the notification appears on screen, in case you want to trigger an animation
- `on_hide()` - This function will be called before the notification leaves the screen, in case you want to trigger an animation

# Upgrade achievements file structure from v1.0.x

In order to upgrade, please do the following:

- **Copy your personal files from addons/gd-achievements** (If you added new sounds or icons to this folder, move them somewhere else if you want to keep them. Also, move your achievements.json file to the root folder once more)

- **Remove the old gd-achievements version** (Simply remove `addons/gd-achievements` and `achievements_generator.py` if you still have them)

- **Install new version** (see "How to install in your project?")

- **Run achievements_generator.py in the same folder as your achievements.json**

If you followed these steps correctly, both these files should be in the root folder of your project. If they aren't, make sure to move them accordingly.
When you run achievements_generator.py with an old achievements.json file, you will get a prompt asking you if you'd like to update it. You will be asked to provide a new `key` for each achievement. You may also update the `icon_path` here, if you wish.

![update achievements](https://imgur.com/K5At6id.png)

- **Move your achievements.json file to the `gd-achievements` folder**
  (NOT the `addons/gd-achievements` folder, the new one created in the root)

# Q/A

## How to get branch for Godot 3.x.x ?
Now code for Godot 3.x.x is placed to ```godot3``` branch and you should switch to this if you need it

## I have an error "The Identifier "AchievementsManager" is not declared in the current scope"!

Check that "addons/gd-achievements/scripts/achievements_manager.gd" file activated as singleton (check <b>How to install in your project?</b>)

## Plugin doesn't work on Android devices
You must add to your exporter ```.json``` format for non-resources export:

```Export => Click on Android Presets => Go to Resources tab``` and set ```.json``` as filter for resources to export.

![image](https://user-images.githubusercontent.com/15859698/226280315-4a3d872b-4090-4f84-856d-5d081b32556a.png)

<i>Thanks to Dark8Ghost for the found fix</i>

# I'll accept all problems and suggestions that you write in the repository on GitHub on "Issues" section
