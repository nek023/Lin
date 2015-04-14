# Lin

Lin is a Xcode plugin that provides auto-completion for `NSLocalizedString`.  
Both Objective-C and Swift are supported.

[![Build Status](https://travis-ci.org/questbeat/Lin.svg?branch=master)](https://travis-ci.org/questbeat/Lin)

![Screenshot](https://raw.github.com/questbeat/Lin/master/screenshot.gif)


## Installation

Download the project and build it, and then relaunch Xcode.  
Lin will be installed in `~/Library/Application Support/Developer/Shared/Xcode/Plug-ins` automatically.

If you want to uninstall Lin, remove Lin.xcplugin in the `Plug-ins` directory.


## Notes

* Xcode 6 or later is supported
* Supported functions
  * NSLocalizedString
  * NSLocalizedStringFromTable
  * NSLocalizedStringFromTableInBundle
  * NSLocalizedStringWithDefaultValue


## Troubleshooting

### I installed Lin by using Alcatraz, and it doesn't work.

1. Remove all cached data of Alcatraz: `rm -rf ~/Library/Application\ Support/Alcatraz`
2. Reinstall Lin and restart Xcode.


## License

Lin is released under the **MIT License**.

> Copyright (c) 2014 Katsuma Tanaka
>
> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
>
> The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
>
> THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
