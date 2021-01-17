# File generator script code is under MIT License
# Copyright (c) 2020 Valeriy Zubko

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

VERSION = "1.1.1-beta"

import json

dataSet = {} # main data set for json file

isStopped = False # for working of main function

achievementName = None
achievementDesc = None
achievementProgressValue = None
achievementIconPath = None
achievementSoundPath = None

print("\nAchievement JSON File Generator")
print("by 5FB5")
print("Version: " + VERSION)
print("___________________________________")

def generateJson(data):
    print("\n___________________________________")

    print("Generating JSON...")
    with open('achievements.json', 'w') as fileResult:
        json.dump(data, fileResult)

    print("File 'achievements.json' created and saved in current folder!")
    pass

while (isStopped == False):
    # Enter name of achievement
    achievementName = input("\nAchievement's name: ")    
    dataSet[achievementName] = {}

    # Enter achievement's description
    achievementDesc = input("Achievement's description: ")
    dataSet[achievementName]['description'] = achievementDesc

    isASecretAchievement = input("Is it a secret achievement? \ny/n: ")
    dataSet[achievementName]['is_secret'] = 1 if isASecretAchievement == 'y' else 0

    # Add achievement's progress if you need
    isHaveProgress = input("Is it have a progress? \ny/n: ")
    achievementProgressValue = input("\nEnter maximum value of a progress: ") if isHaveProgress == 'y' else 0
    dataSet[achievementName]['progress'] = int(achievementProgressValue)

    # Set icon's path
    if (achievementIconPath == None):
        achievementIconPath = input("Enter icon's path (in Godot's format): ")
        dataSet[achievementName]['icon_path'] = achievementIconPath
    else:
        isOverwriteIconPath = input('Do you want to set previous icon path? \ny/n: ')
        achievementIconPath = achievementNewIconPath = input("Enter new icon's path (in Godot's format): ") if isOverwriteIconPath == 'n' else achievementIconPath
        dataSet[achievementName]['icon_path'] = achievementNewIconPath if isOverwriteIconPath == 'n' else achievementIconPath

    bContinue = input("Do you want to add new achievement?: y/n: ")
    if (bContinue == "n"):
        isStopped = True

# After that we generate JSON
generateJson(dataSet)