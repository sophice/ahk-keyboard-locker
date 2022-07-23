#Persistent
FileInstall, unlocked.ico, unlocked.ico, 0
FileInstall, locked.ico, locked.ico, 0
initialize()

initialize()
{
	;tracks whether tray notifications are toggled on or off
	global notray = 0

	;tracks whether or not the keyboard is currently locked
	global locked = false

	;the unlock password
	global password = "unlock"

	;initialize the tray icon and menu
	Menu, Tray, Icon, unlocked.ico
	Menu, Tray, NoStandard
	Menu, Tray, Tip, Press Ctrl+Alt+L to lock your keyboard
	Menu, Tray, Add, Lock keyboard, ToggleKeyboard
	Menu, Tray, Add, Hide tray notifications, ToggleTray
	Menu, Tray, Add, Exit, Exit
	TrayTip,,To lock your keyboard press Ctrl+Alt+L.,10,1
}

;shortcut to lock the keyboard (can't be called if keyboard is already locked)
^!l::
	;don't block Ctrl, Alt or L key-up
	KeyWait, Ctrl
	KeyWait, Alt
	KeyWait, l

	LockKeyboard(true)
return

;"Lock/Unlock keyboard" menu clicked
ToggleKeyboard()
{
	global locked

	if (locked = false) {
		LockKeyboard(true)
	} else {
		LockKeyboard(false)
	}
}

;"Hide/Show tray notifications" menu clicked
ToggleTray()
{
	global notray

	if (notray = 0) {
		notray = 1
		Menu, Tray, Rename, Hide tray notifications, Show tray notifications
	} else {
		notray = 0
		Menu, Tray, Rename, Show tray notifications, Hide tray notifications
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
    global timer

	;whether or not we should display tooltips
	global notray
	
	;whether or not the keyboard is currently locked
	global locked

	;handle pointing to the keyboard hook
	static hHook = 0

	;already (un)locked, no action necessary.
	if ((hHook!=0) = (lock!=0)) {
		return
	}
 
	if (lock) {
		Menu, Tray, Icon, locked.ico
		Menu, Tray, Tip, Type "unlock" to unlock your keyboard
		hHook := DllCall("SetWindowsHookEx", "Ptr", WH_KEYBOARD_LL:=13, "Ptr", RegisterCallback("Hook_Keyboard","Fast"), "Uint", DllCall("GetModuleHandle", "Uint", 0, "Ptr"), "Uint", 0, "Ptr")
		locked := true
		Menu, Tray, Rename, Lock keyboard, Unlock keyboard

		if (notray = 0) {
			;remind user what the password is
			TrayTip,,Your keyboard is now locked.`nType in "unlock" to unlock it.,10,1
		}
	} else {
		Menu, Tray, Icon, unlocked.ico
		Menu, Tray, Tip, Press Ctrl+Alt+L to lock your keyboard
		DllCall("UnhookWindowsHookEx", "Ptr", hHook)
		hHook = 0
		locked := false
		Menu, Tray, Rename, Unlock keyboard, Lock keyboard

		if (notray = 0) {
			TrayTip,,Your keyboard is now unlocked.`nPress Ctrl+Alt+L to lock it again.,10,1
		}
	}
}

;Catch and discard keypresses when the keyboard is locked, and monitor for password inputs
Hook_Keyboard(nCode, wParam, lParam)
{
    ;the password we're trying to match
	global password

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
	if (!isKeyUp) {
	    expectedCharacter := SubStr(password, count+1, 1)
        expectedScanCode := GetKeySC(expectedCharacter)
        requiresShift := requiresShift(expectedCharacter)

        ;did they type the correct next password letter?
	    if(expectedScanCode == gotScanCode && requiresShift == shifted) {
	        count := count + 1

	        ;password is complete!
	        if(count == StrLen(password)) {
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