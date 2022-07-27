# AutoHotkey Keyboard Locker

This is an AutoHotkey script you can use to temporarily block keyboard input. When your keyboard is locked by this script, keypresses will be caught by the script and blocked, until you unlock your keyboard again.

# What is it for?

- Lock your keyboard while wiping it clean.
- Allow a baby/toddler to tap away on your keyboard without messing up your system.
- Defend against your cat walking across/sleeping on your keyboard.
- Mess with coworkers.
- Block coworkers from messing with you.

Note: This is not security software and is easily bypassed. Only use it for convenience, not security.

# How to use it

1) Install [AutoHotkey](https://www.autohotkey.com/) version 1.x in order to run .ahk scripts. Not tested with AutoHotkey version 2.
2) Download [all files](https://github.com/sophice/ahk-keyboard-locker/archive/refs/heads/main.zip) from this repo and extract/place them where you want.
3) Run keyboard-locker.ahk.
4) Lock the keyboard either by pressing the default shortcut "Ctrl+Alt+k", or by right clicking on the tray icon and selecting "Lock keyboard".
5) Unlock the keyboard either by typing the default password "unlock", or by right clicking on the tray icon and selecting "Unlock keyboard".

The shortcut and password can easily be changed by editing the script.

# Known issues

- Some media/function keys or Windows system shortcuts may not be blocked.
- Some keys (especially modifiers) may get "stuck" after typing the unlock password, requiring you to press them again to get them unstuck.
- There is sometimes a slight delay after typing the password before the keyboard is unlocked.

Feel free to submit a PR if you have improvements for these issues!

# Potential future improvements

- Better configuration: command line parameters to customize the script on run, and a config file to provide your own defaults.
- Stealth mode: hide the tray icon and disable tooltips on lock, making it slightly more difficult to bypass the script.
- Temporary password: change the password at run time to avoid using the one that is readable in the script itself.
- Lock the mouse: lock the mouse, keyboard, or both.
- Unlock timer: automatically unlock after a period of time.
- Inactivity lock: automatically lock after a period of inactivity.
- Scheduled lock: automatically lock and unlock on a schedule.

# Credits

This script is inspired by the Keyboard Locker script from this HowToGeek [article](https://www.howtogeek.com/howto/11570/disable-the-keyboard-with-a-keyboard-shortcut-in-windows/).
