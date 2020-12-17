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

VERSION = "1.0.1-beta"

isStopped = False # for working of main function

dataSet = {} # main data set for json file

import json
from termcolor import colored, cprint # must be installed
from colorama import init # must be installed

init()

print("\nAchievement JSON File Generator")
print("by 5FB5")
print("ver. " + VERSION)
print("___________________________________")

def generateJson(data):
    print("\n___________________________________")

    print("Generating JSON...")
    with open('achievements.json', 'w') as fileResult:
        json.dump(data, fileResult)

    print(colored("File 'achievements.json' created and saved in current folder!", 'green'))
    pass

while (isStopped == False):
    achievementName = input("\nAchievement's name: ")    
    dataSet[achievementName] = {}

    achievementDesc = input("Achievement's description: ")
    dataSet[achievementName]['description'] = achievementDesc

    isHaveProgress = input("Is it have a progress? \ny/n: ")
    achievementProgressValue = input("\nEnter maximum value of a progress: ") if isHaveProgress == 'y' else 0
    dataSet[achievementName]['progress'] = int(achievementProgressValue)

    achievementIconPath = input("Enter icon's path (in Godot's format): ")
    dataSet[achievementName]['icon_path'] = achievementIconPath

    bContinue = input("Do you want to add new achievement?: y/n: ")
    if (bContinue == "n"):
        isStopped = True

generateJson(dataSet)