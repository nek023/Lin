# Lin
Xcode4 plugin showing completion for NSLocalizedString and localizedStringForKey:value:table:

[![Build Status](https://travis-ci.org/questbeat/Lin.png?branch=master)](https://travis-ci.org/questbeat/Lin)


## Lin for Xcode5
**A new version with Xcode5 support is now available!**

[questbeat/Lin](https://github.com/questbeat/Lin-Xcode5)


## Installation
Build the Lin, then the plugin will automatically be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins`.  
Relaunch Xcode and Lin will make your life easier.


## Usage
After installation `Enable Lin` will appear in Edit menu.  

![lin_ss01.png](http://adotout.sakura.ne.jp/github/Lin/lin_ss01.png)

Selecting a line with either:

- NSLocalizedString( @"", )
- localizedStringForKey: @"" value: table:
- NSLocalizedStringFromTable( @"", , )
- NSLocalizedStringFromTableInBundle( @"", , , )
- NSLocalizedStringWithDefaultValue( @"", , , , )

will show completion (see **Warnings** section no popup shows).

![lin_ss02.png](http://adotout.sakura.ne.jp/github/Lin/lin_ss02.png)

Narrowing down the lists by key.  

![lin_ss03.png](http://adotout.sakura.ne.jp/github/Lin/lin_ss03.png)

You can modify value directly from the popover window. (`.strings` file containing key will be automatically updated) 

![lin_ss04.png](http://adotout.sakura.ne.jp/github/Lin/lin_ss04.png)


## Warnings

.strings files must be **UTF8**

Completion popup **won't show** with **empty .strings** files

After **modifying** a .string file, dont forget to **save** otherwise new strings won't appear in completion popup


## License
*Lin* is released under the **MIT License**, see *LICENSE.txt*.
