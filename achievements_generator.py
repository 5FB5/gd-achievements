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

VERSION = "1.2.0-beta"

import json
import os
import sys

dataSet = {} # main data set for json file

isStopped = False # for working of main function

achievementName = None
achievementDesc = None
achievementProgressValue = None
achievementIconPath = None
achievementSoundPath = None
 
def generateNewJson(data):
    print("\n___________________________________")

    print("Generating JSON...")
    with open('achievements.json', 'w') as fileResult:
        json.dump(data, fileResult)

    print("File 'achievements.json' created and saved in current folder!")
    isStopped = False
    pass

def generateInCurrentJson(data):
    print("\n___________________________________")

    print("Append data in current JSON file...")
    with open("achievements.json", "r+") as fileResult:
        dataFinal = json.load(fileResult)
        dataFinal.update(data)
        fileResult.seek(0)
        json.dump(dataFinal, fileResult)

    print("'achievements.json' file data updated and saved in current folder!")
    global isStopped
    isStopped = True
    pass

def createNewFile():
    # Set bContinue variable as loop flag
    bContinue = 'y'
    while (bContinue == 'y'):
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
        global achievementIconPath
        if (achievementIconPath == None):
            achievementIconPath = input("Enter icon's path (in Godot's format): ")
            dataSet[achievementName]['icon_path'] = achievementIconPath
        else:
            isOverwriteIconPath = input('Do you want to set previous icon path? \ny/n: ')
            achievementIconPath = achievementNewIconPath = input("Enter new icon's path (in Godot's format): ") if isOverwriteIconPath == 'n' else achievementIconPath
            dataSet[achievementName]['icon_path'] = achievementNewIconPath if isOverwriteIconPath == 'n' else achievementIconPath

        # Set flag to 'y' or 'n' to continue adding achievements or not
        bContinue = input("Do you want to add new achievement?: y/n: ")
        
    generateNewJson(dataSet)

    pass

def checkIsNameExists(data, name):
    dataKeysName = data.keys()
    for i in dataKeysName:
        if (name == i):
            return False

    return True

def addDataInCurrentFile():
    # Do you want to modify current file?
    isFileCreate = input('\n"achievements.json" exists. Do you want to add data in current file? \ny/n: ')
    
    # If yes
    if (isFileCreate == 'y'):
        # Set bContinue variable as loop flag
        bContinue = 'y'
        # While flag is 'y' add achievement you need
        while (bContinue == 'y'):
            # Enter name of achievement
            achievementName = input("\nAchievement's name: ")
 
            # Get data from current JSON for comparison
            with open('achievements.json', 'r') as currentFile:
                dataJson = json.load(currentFile)

            # Check this data if achievement name exists
            if (checkIsNameExists(dataJson, achievementName) == True):    
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
                global achievementIconPath
                if (achievementIconPath == None):
                    achievementIconPath = input("Enter icon's path (in Godot's format): ")
                    dataSet[achievementName]['icon_path'] = achievementIconPath
                else:
                    isOverwriteIconPath = input('Do you want to set previous icon path? \ny/n: ')
                    achievementIconPath = achievementNewIconPath = input("Enter new icon's path (in Godot's format): ") if isOverwriteIconPath == 'n' else achievementIconPath
                    dataSet[achievementName]['icon_path'] = achievementNewIconPath if isOverwriteIconPath == 'n' else achievementIconPath

                # Set flag to 'y' or 'n' to continue adding achievements or not
                bContinue = input("Do you want to add new achievement? \ny/n: ")
            
            else:
                # If name is exists in file we entering new name again
                print('This name is exists! Try to add achievement with another name!\n')
        
        # When we've added achievements bContinue flag is 'n' and call the generating function
        generateInCurrentJson(dataSet)

    # If we don't want to modify file, call the function that creates file from skretch
    else:
        createNewFile()

print("\nAchievement JSON File Generator")
print("by 5FB5")
print("Version: " + VERSION)
print("___________________________________")

while (isStopped == False):
    # If file not exists, create new
    if (not os.path.isfile("achievements.json")):
        createNewFile()
    # Else add data in current file
    else:
        addDataInCurrentFile()