<p align="center"> <img width=80 height=80 src="https://imgur.com/vIftQvp.png"/></p>
<h1><p align="center">Achievement System Plugin for Godot Engine 4.4.1 </p></h1>

<p align="center">This is a plugin that allows you to create custom achievements with notification in UI with simple API</p>

<p align="center">
<img src=https://imgur.com/sMhvf6T.png"</img>
</p>

<p align="center">
<img src="https://imgur.com/24MtHit.png"</img>
</p>

# Usage
<b>More about plugin and API you can read in</b> ```addons/gd_achievements``` <b>folder and in <a href="https://github.com/5FB5/gd-achievements/wiki">wiki</a> </b>

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
