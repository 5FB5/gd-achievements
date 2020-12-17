# 1 - создаётся главный объект с названием ачивки
# 2 - в объекте параметры: описание, прогресс, если есть

VERSION = "1.0.0-beta"

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

    print(colored("File created!", 'green'))
    pass

while (isStopped == False):
    achievementName = input("\nAchievement's name: ")    
    dataSet[achievementName] = {}

    achievementDesc = input("Achievement's description: ")
    dataSet[achievementName]['description'] = achievementDesc

    isHaveProgress = input("Is it have a progress? \ny/n: ")
    achievementProgressValue = input("\nEnter maximum value of a progress: ") if isHaveProgress == 'y' else 0
    dataSet[achievementName]['progress'] = achievementProgressValue

    bContinue = input("Do you want to add new achievement?: y/n: ")
    if (bContinue == "n"):
        isStopped = True

generateJson(dataSet)