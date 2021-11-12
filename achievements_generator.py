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

VERSION = "1.4.0-release"

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
        # Enter key of achievement
        achievementKey = input("\nAchievement's key (You will have to use this from your code, pick a code friendly key like 'my_achievement'): ")
        dataSet[achievementKey] = {}

        # Enter name of achievement
        achievementName = input("\nAchievement's name: ")    
        dataSet[achievementKey]['name'] = achievementName

        # Enter achievement's description
        achievementDesc = input("Achievement's description: ")
        dataSet[achievementKey]['description'] = achievementDesc

        isASecretAchievement = input("Is it a secret achievement? \ny/n: ")
        dataSet[achievementKey]['is_secret'] = 1 if isASecretAchievement == 'y' else 0

        # Add achievement's goal if you need
        achievementProgress = input("Does it have progress? \ny/n: ")
        if (achievementProgress == 'y'):
            achievementProgressValue = input("\nEnter maximum value of progress: ")
            dataSet[achievementKey]['goal'] = int(achievementProgressValue)
            dataSet[achievementKey]['current_progress'] = 0

        # Set icon's path
        global achievementIconPath
        if (achievementIconPath == None):
            achievementIconPath = input("Enter icon's path (in Godot's format): ")
            dataSet[achievementKey]['icon_path'] = achievementIconPath
        else:
            isOverwriteIconPath = input('Do you want to set previous icon path? \ny/n: ')
            achievementIconPath = achievementNewIconPath = input("Enter new icon's path (in Godot's format): ") if isOverwriteIconPath == 'n' else achievementIconPath
            dataSet[achievementKey]['icon_path'] = achievementNewIconPath if isOverwriteIconPath == 'n' else achievementIconPath

        # Set the default value that the player has not received this achievement at the moment
        dataSet[achievementKey]['achieved'] = False

        # Set flag to 'y' or 'n' to continue adding achievements or not
        bContinue = input("Do you want to add new achievement?: y/n: ")
        
    generateNewJson(dataSet)

    pass

def checkKeyExists(data, name):
    dataKeysName = data.keys()
    for i in dataKeysName:
        if (name == i):
            return False

    return True

def checkAchievementsAreOld():
    with open('achievements.json', 'r') as currentFile:
        dataJson = json.load(currentFile)
        dataKeysName = dataJson.keys()
        for i in dataKeysName:
            if ('is_have' in dataJson[i]):
                return True
        return False

def promptUpdate():
    wantUpdate = input("\nIt looks like your achievements.json file is from a previous version, would you want to update it? \ny/n: ")
    if (wantUpdate == 'y'):
        with open('achievements.json', 'r') as currentFile:
            newDataSet = {}
            dataJson = json.load(currentFile)
            dataKeysName = dataJson.keys()
            for i in dataKeysName:
                print("\nUpdating achievement '" + i + "'")
                achievementKey = input("\nPlease enter the new achievement's key (You will have to use this from your code, pick a code friendly key like 'my_achievement'): ")
                wantUpdateIconPath = input("\nDo you want to update icon's path? \ny/n: ") == 'y'
                if (wantUpdateIconPath):
                    achievementIconPath = input("\nEnter new icon's path (in Godot's format): ")
                newDataSet[achievementKey] = {
                    'name': i,
                    'description': dataJson[i]['description'],
                    'is_secret': True if dataJson[i]['is_secret'] == 1 else False,
                    'icon_path': achievementIconPath if wantUpdateIconPath else dataJson[i]['icon_path'],
                    'achieved': True if dataJson[i]['is_have'] == 1 else False,
                }
                if (dataJson[i]['progress'] > 0):
                    newDataSet[achievementKey]['goal'] = dataJson[i]['progress']
                    newDataSet[achievementKey]['current_progress'] = 0
                for key in dataJson[i]:
                    # parsing extra keys added by the user
                    if (key not in newDataSet[achievementKey] and key != 'is_have' and key != 'progress'):
                        newDataSet[achievementKey][key] = dataJson[i][key]
                
            print("\nUpdate complete, writing to file...")
            generateNewJson(newDataSet)



def addDataInCurrentFile():
    # Do you want to modify current file?
    isFileCreate = input('\n"achievements.json" exists. Do you want to add data in current file? \ny/n: ')
    
    # If yes
    if (isFileCreate == 'y'):
        # Set bContinue variable as loop flag
        bContinue = 'y'
        # While flag is 'y' add achievement you need
        while (bContinue == 'y'):
            # Enter key of achievement
            achievementKey = input("\nAchievement's key (You will have to use this from your code, pick a code friendly key like 'my_achievement'): ")
 
            # Get data from current JSON for comparison
            with open('achievements.json', 'r') as currentFile:
                dataJson = json.load(currentFile)

            # Check this data if achievement name exists
            if (checkKeyExists(dataJson, achievementKey) == True):    
                dataSet[achievementKey] = {}

                # Enter name of achievement
                achievementName = input("\nAchievement's name: ")    
                dataSet[achievementKey]['name'] = achievementName

                # Enter achievement's description
                achievementDesc = input("Achievement's description: ")
                dataSet[achievementKey]['description'] = achievementDesc

                isASecretAchievement = input("Is it a secret achievement? \ny/n: ")
                dataSet[achievementKey]['is_secret'] = 1 if isASecretAchievement == 'y' else 0

                # Add achievement's goal if you need
                achievementProgress = input("Does it have progress? \ny/n: ")
                if (achievementProgress == 'y'):
                    achievementProgressValue = input("\nEnter maximum value of progress: ")
                    dataSet[achievementKey]['goal'] = int(achievementProgressValue)
                    dataSet[achievementKey]['current_progress'] = 0

                # Set icon's path
                global achievementIconPath
                if (achievementIconPath == None):
                    achievementIconPath = input("Enter icon's path (in Godot's format): ")
                    dataSet[achievementKey]['icon_path'] = achievementIconPath
                else:
                    isOverwriteIconPath = input('Do you want to set previous icon path? \ny/n: ')
                    achievementIconPath = achievementNewIconPath = input("Enter new icon's path (in Godot's format): ") if isOverwriteIconPath == 'n' else achievementIconPath
                    dataSet[achievementKey]['icon_path'] = achievementNewIconPath if isOverwriteIconPath == 'n' else achievementIconPath
                
                # Set the default value that the player has not received this achievement at the moment
                dataSet[achievementKey]['achieved'] = False
                
                # Set flag to 'y' or 'n' to continue adding achievements or not
                bContinue = input("Do you want to add new achievement? \ny/n: ")
            
            else:
                # If name is exists in file we entering new name again
                print('This name is exists! Try to add achievement with another name!\n')
        
        # When we've added achievements bContinue flag is 'n' and call the generating function
        generateInCurrentJson(dataSet)

    # If we don't want to modify file, call the function that creates file from skretch
    else:
        isExit = input('You really want to quit or create new file? \nq\c: ')
        sys.exit() if isExit == 'q' else createNewFile()

print("\nAchievement JSON File Generator")
print("Initially developed by 5FB5")
print("Contributors: jabsatz (Glass Brick Studio)")
print("Version: " + VERSION)
print("___________________________________")

while (isStopped == False):
    # If file not exists, create new
    if (not os.path.isfile("achievements.json")):
        createNewFile()
    # Prompt update if achievements.json is from previous version
    elif checkAchievementsAreOld() == True:
        promptUpdate()    
    # Else add data in current file
    else:
        addDataInCurrentFile()