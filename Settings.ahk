class Settings
{
    static iniFile := ""

    Ini()
    {
        if(!Settings.iniFile)
        {
            Settings.iniFile := new Ini("settings.ini")
            Settings.iniFile.Load()
        }
        return Settings.iniFile
    }

    Get(key, default)
    {
        return Settings.Ini().GetMain(key, default)
    }

    Set(key, value)
    {
        Settings.Ini().SetMain(key, value)
        Settings.Ini().Save()
    }

    LockOnOpen()
    {
        return this.Get("lock-on-open", false)
    }

    SetLockOnOpen(value)
    {
        this.Set("lock-on-open", value)
    }

    CloseOnUnlock()
    {
        return Settings.Ini().getMain("close-on-unlock", false)
    }

    SetCloseOnUnlock(value)
    {
        this.Set("close-on-unlock", value)
    }

    HideTooltips()
    {
        return Settings.Ini().getMain("hide-tooltips", false)
    }

    SetHideTooltips(value)
    {
        this.Set("hide-tooltips", value)
    }

    DisableKeyboardShortcut()
    {
        return Settings.Ini().getMain("disable-keyboard-shortcut", false)
    }

    SetDisableKeyboardShortcut(value)
    {
        this.Set("disable-keyboard-shortcut", value)
    }
}