class Settings
{
    __New()
    {
        this.ini := new Ini("settings.ini")
        this.ini.Load()

        this.map := {}

        this.map.Shortcut := {key:"shortcut", default:"^!k"}
        this.map.ShortcutHint := {key:"shortcut-hint", default:"Ctrl+Alt+k"}
        this.map.DisableKeyboardShortcut := {key:"disable-keyboard-shortcut", default:false}

        this.map.Password := {key:"password", default:"unlock"}
        this.map.DisablePassword := {key:"disable-password", default:false}

        this.map.LockOnOpen := {key:"lock-on-open", default:false}
        this.map.CloseOnUnlock := {key:"close-on-unlock", default:false}
        this.map.HideTooltips := {key:"hide-tooltips", default:false}
        this.map.LockMouse := {key:"lock-mouse", default:false}
    }

    __Call(method, params*)
    {
        mode := "Get"

        if(SubStr(method, 1, 3) == "Set")
        {
            mode := "Set"
            method := SubStr(method, 4)
        }

        if(this.map.HasKey(method))
        {
            ;MsgBox, % "mode=" . mode . ", method=" . method . ", param=" . params[1] . ", key=" . this.map[method].key . ", default=" . this.map[method].default

            if(mode == "Get")
            {
                return this.Get(this.map[method].key, this.map[method].default)
            } else if(mode == "Set") {
                return this.Set(this.map[method].key, params[1])
            } else {
                MsgBox, % "Unhandled Settings mode " . mode
                ExitApp
            }
        }
    }

    Get(key, default)
    {
        ;MsgBox, % "key=" . key . ", ini=" . this.ini.GetMain(key, default)
        return this.ini.GetMain(key, default)
    }

    Set(key, value)
    {
        this.ini.SetMain(key, value)
        this.ini.Save()
    }
}