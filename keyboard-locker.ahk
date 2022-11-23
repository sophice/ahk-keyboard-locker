;#Persistent
;#SingleInstance Ignore

#Include Ini.ahk
#Include Settings.ahk

FileInstall, unlocked.ico, unlocked.ico, 0
FileInstall, locked.ico, locked.ico, 0

settings := new Settings()

;(DO NOT CHANGE) tracks whether or not the keyboard is currently locked
locked := false

;create the tray icon and do initial setup
initialize()

;set up the keyboard shortcut to lock the keyboard
Hotkey, % settings.Shortcut(), ShortcutTriggered

;end execution here - the rest of the file is functions and callbacks
return

initialize()
{
	;initialize the tray icon and menu
	Menu, Tray, Icon, %A_ScriptDir%\unlocked.ico
	Menu, Tray, NoStandard
	Menu, Tray, Tip, % "Press " . settings.ShortcutHint() . " to lock your keyboard"
	Menu, Tray, Add, Lock keyboard, ToggleKeyboard
	if (settings.HideTooltips()) {
		Menu, Tray, add, Show tray notifications, ToggleTray
	} else {
		Menu, Tray, add, Hide tray notifications, ToggleTray
	}
	Menu, Tray, Add, Exit, Exit

	if (settings.LockOnOpen()) {
		LockKeyboard(true)
	} else if (!settings.HideTooltips()) {
		TrayTip,,% "Press " . settings.ShortcutHint() . " to lock your keyboard",10,1
	}
}

;callback for when the keyboard shortcut is pressed
ShortcutTriggered:
    ;check if shortcut is disabled in settings
    if (settings.DisableShortcut())
    {
        return
    }

    ;if we're already locked, stop here
    if (locked)
    {
        return
    }

	;wait for each shortcut key to be released, so they don't get "stuck"
	for index, key in StrSplit(settings.ShortcutHint(), "+")
	{
		KeyWait, %key%
    }

	LockKeyboard(true)
return


;"Lock/Unlock keyboard" menu clicked
ToggleKeyboard()
{
	global locked

	if (locked) {
		LockKeyboard(false)
	} else {
		LockKeyboard(true)
	}
}

;"Hide/Show tray notifications" menu clicked
ToggleTray()
{
	if (settings.HideTooltips()) {
	    settings.SetHideTooltips(false)
		Menu, Tray, Rename, Show tray notifications, Hide tray notifications
	} else {
	    settings.SetHideTooltips(true)
		Menu, Tray, Rename, Hide tray notifications, Show tray notifications
	}
}

;"Exit" menu clicked
Exit()
{
	ExitApp
}

;Lock or unlock the keyboard
LockKeyboard(lock)
{
	global locked

	;handle pointing to the keyboard hook
	static hHook = 0

	;lock status already matches what we were asked to do, no action necessary
	if ((hHook != 0) = lock) {
		return
	}
 
	if (lock) {
	    ;check that we didn't leave ourselves without a way to unlock again
	    if(settings.DisablePassword() && settings.LockMouse())
	    {
	        MsgBox, You have disabled password unlocking and enabled mouse locking, which will prevent you from unlocking your system. Please re-enable one or the other.
	        return
	    }

	    ;change the tray icon to a lock
		Menu, Tray, Icon, %A_ScriptDir%\locked.ico

        ;hint at the unlock password
		Menu, Tray, Tip, % "Type """ . settings.Password() . """ to unlock your keyboard"

        ;update menu to unlock
		Menu, Tray, Rename, Lock keyboard, Unlock keyboard

        ;lock the keyboard
		hHook := DllCall("SetWindowsHookEx", "Ptr", WH_KEYBOARD_LL:=13, "Ptr", RegisterCallback("Hook_Keyboard","Fast"), "Uint", DllCall("GetModuleHandle", "Uint", 0, "Ptr"), "Uint", 0, "Ptr")
		locked := true

		;also lock the mouse, if configured to do so
		if (settings.LockMouse()) {
			Hotkey, LButton, doNothing
			Hotkey, RButton, doNothing
			Hotkey, MButton, doNothing
			BlockInput, MouseMove
		}

        ;remind user what the password is
		if (!settings.HideTooltips()) {
			TrayTip,,% "Your keyboard is now locked.`nType """ . settings.Password() . """ to unlock it.",10,1
		}
	} else {
        ;unlock the keyboard
		DllCall("UnhookWindowsHookEx", "Ptr", hHook)
		hHook := 0
		locked := false

        ;also unlock the mouse, if configured to do so
        if (settings.LockMouse()) {
            Hotkey, LButton, Off
            Hotkey, MButton, Off
            Hotkey, RButton, Off
            BlockInput, MouseMoveOff
        }

	    ;change tray icon back to unlocked
		Menu, Tray, Icon, %A_ScriptDir%\unlocked.ico

        ;hint at the keyboard shortcut to lock again
		Menu, Tray, Tip, % "Press " . settings.ShortcutHint() . " to lock your keyboard"

        ;update menu to lock
		Menu, Tray, Rename, Unlock keyboard, Lock keyboard

        ;remind user what the keyboard shortcut to lock is
		if (!settings.HideTooltips()) {
			TrayTip,,% "Your keyboard is now unlocked.`nPress " . settings.ShortcutHint() . " to lock it again.",10,1
		}

		if(settings.CloseOnUnlock())
		{
		    ExitApp
		}
	}
}

;Catch and discard keypresses when the keyboard is locked, and monitor for password inputs
Hook_Keyboard(nCode, wParam, lParam)
{
    ;track our position while correctly typing the password
	static count = 0

    ;is this a keyUp event (or keyDown)
    isKeyUp := NumGet(lParam+0, 8, "UInt") & 0x80

    ;get the scan code of the key pressed/released
    gotScanCode := NumGet(lParam+0, 4, "UInt")

    ;track the left/right shift keys, to handle capitals and symbols in passwords, because getkeystate calls don't work with our method of locking the keyboard
    ;if you can figure out how to use a getkeystate call to check for shift, or you have a better way to handle upper case letters and symbols, let me know
	static shifted = 0
    if(gotScanCode = 0x2A || gotScanCode = 0x36) {
        if(isKeyUp) {
            shifted := 0
        } else {
            shifted := 1
        }
        return 1
    }

	;check password progress/completion
	if (!settings.DisablePassword() && !isKeyUp) {
	    expectedCharacter := SubStr(settings.Password(), count+1, 1)
        expectedScanCode := GetKeySC(expectedCharacter)
        requiresShift := requiresShift(expectedCharacter)

        ;did they type the correct next password letter?
	    if(expectedScanCode == gotScanCode && requiresShift == shifted) {
	        count := count + 1

	        ;password is complete!
	        if(count == StrLen(settings.Password())) {
                count = 0
                shifted = 0
                LockKeyboard(false)
            }
	    } else {
			count = 0
        }
    }

	return 1
}

;Determine if this character requires shift to be pressed (capital letter or symbol)
requiresShift(chr)
{
    ;upper case characters always require shift
    if(isUpperCase(chr)) {
        return true
    }

    ;symbols that require shift
    static symbols = ["~", "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "_", "+", "{", "}", "|", ":", """", "<", ">", "?"]
    if(inArray(chr, symbols)) {
        return true
    }

    ;anything else is false
    return false
}

;Is the string (or character) upper case
isUpperCase(str)
{
    if str is upper
        return true
    else
        return false
}

;Is the string (or character) lower case
isLowerCase(str)
{
    if str is lower
        return true
    else
        return false
}

;Check if the haystack array contains the needle
inArray(needle, haystack) {
    ;only accept objects and arrays
	if(!IsObject(haystack) || haystack.Length() == 0) {
	    return false
	}

	for index, value in haystack {
		if (value == needle) {
		    return index
		}
    }
	return false
}

;this is used to block mouse input
doNothing:
return
