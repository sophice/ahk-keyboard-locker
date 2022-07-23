# AutoHotkey Keyboard Locker

This is an AutoHotkey script you can use to temporarily block keyboard input. When your keyboard is locked by this script, keypresses will be caught by the script and blocked until you unlock your keyboard again.

# What is it for?

Some potential uses for this script:

- Lock your keyboard while wiping it clean.
- Allow a baby/toddler to tap away on your keyboard without messing up your system.
- Make it harder for people to mess with your computer when you briefly step away.

# How to use it

First you must install [AutoHotkey](https://www.autohotkey.com/) in order to run .ahk scripts.

After running the script, lock the keyboard either by pressing the default shortcut "Ctrl+Alt+L", or by right clicking on the tray icon and selecting "Lock keyboard".

Unlock the keyboard either by typing the default password "unlock", or by right clicking on the tray icon and selecting "Unlock keyboard".

The shortcut and password can easily be changed to your preference by editing the script.

# Known issues

- Some special function keys or key combinations may not be blocked.
- Some keys (especially modifiers) may get "stuck" after typing the unlock password, requiring you to press them again to get them unstuck.
- There is sometimes a slight delay after typing the password before the keyboard is unlocked.

Feel free to submit a PR if you have improvements for these issues!

# Potential future improvements

- Better configuration: add optional command line parameters to customize the script on run, and add an optional settings file to provide your own defaults.
- Stealth mode: optionally hide the tray icon and tooltips on lock, making it slightly more difficult for others to snoop.
- Temporary password: optionally set the password at the time of locking the keyboard, to avoid using the one that is readable in the script itself.
- Lock the mouse: optionally lock the mouse, or both the mouse and keyboard.

# Credits

This script is inspired by the [Keyboard Locker script from this HowToGeek article](https://www.howtogeek.com/howto/11570/disable-the-keyboard-with-a-keyboard-shortcut-in-windows/), but fixes issues with newer versions of windows and adds a number of new features and improvements.
