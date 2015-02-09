# Lin
Lin is a open source plug-in for **Xcode 5**.  
It lets you search/manage localizations without opening the .strings files.

[![Build Status](https://travis-ci.org/questbeat/Lin-Xcode5.svg?branch=master)](https://travis-ci.org/questbeat/Lin-Xcode5)

![01.png](http://questbe.at/lin/img/screenshots/01.png)

Lin for Xcode 4 (previous version)  
[questbeat/Lin](https://github.com/questbeat/Lin)




## Features
When you are focusing on NSLocalizedString or other functions to get a localized version of a string, Lin shows the list of localizations that contains the inputted key string.

![02.gif](http://questbe.at/lin/img/screenshots/02.gif)

You can add a new localization or remove a localization from the popover.  
(Click +/- button in the bottom left of the popover.)

![03.gif](http://questbe.at/lin/img/screenshots/03.png)

You can also edit key or value of a localization by clicking the row on the table.

![04.png](http://questbe.at/lin/img/screenshots/04.png)

Lin has not only popover mode, but also window mode.  
The window will appear when you drag-and-drop the popover.  
In window mode, the search field can be used to find the localization with a free keyword.

![05.gif](http://questbe.at/lin/img/screenshots/05.gif)


## Installation
Download the project and build it, then relaunch Xcode.  
Lin will be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` automatically.

If you want to uninstall Lin, remove Lin.xcplugin in `Plug-ins` directory.


## Settings
You can enable/disable Lin or show window manually by opening the Lin menu in the Editor menu in Xcode.

![06.png](http://questbe.at/lin/img/screenshots/06.png)


## Notes
* `.strings` files must be UTF-8
* Supported functions:
  * NSLocalizedString
  * NSLocalizedStringFromTable
  * NSLocalizedStringFromTableInBundle
  * NSLocalizedStringWithDefaultValue
  * localizedStringForKey:value:table:
* After modifying a `.string` file, don't forget to save otherwise new strings won't appear in completion popup


## License
*Lin* is released under the **MIT License**, see *LICENSE.txt*.
