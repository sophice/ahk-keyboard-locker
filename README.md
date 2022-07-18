# AutoHotkey Keyboard Disabler

This is an AutoHotkey script you can use to temporarily disable your keyboard system-wide. When your keyboard is disabled by this script, keypresses will be caught by the script and blocked, until you re-enable your keyboard again.

# What is it for?

Some potential uses for this script:

- Lock your keyboard while whiping it clean.
- Allow a toddler to tap away without messing up your system.
- Make it harder for people to mess with your computer when you briefly step away.

# How to use it

After running the script, disable the keyboard either by pressing the default shortcut "Ctrl+Alt+D", or by right clicking on the tray icon and selecting "Disable keyboard".

Enable the keyboard either by typing the default password "enable", or by right clicking on the tray icon and selecting "Enable keyboard".

The shortcut and password can easily be changed to your preference by editing the script.

# Known issues

- Modifier keys may get "stuck" after typing the unlock password, requiring you to press them again to get them unstuck.
- There is sometimes a slight delay after typing the password before the keyboard is enabled.

Feel free to submit a PR if you have fixes for these issues!

# Potential future improvements

- Stealth mode: disable the keyboard and hide the tray icon and tooltips so that others can't easily see why it's disabled, making it more difficult to enable the keyboard.
- Temporary password: allow users to set the password at the time of locking the keyboard, so that others can't know your password from the source file or tooltips.
- Disable the mouse: allow users to also disable the mouse, or both the mouse and keyboard.

# Credits

This script is based on the [Keyboard Locker script from this HowToGeek article](https://www.howtogeek.com/howto/11570/disable-the-keyboard-with-a-keyboard-shortcut-in-windows/).
