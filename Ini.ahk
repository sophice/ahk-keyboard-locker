class Ini {
    filename := ""
    data := {}
    mainSection := ""

    __New(filename)
    {
        this.filename := filename
    }

    Load()
    {
        IniRead, sections, % this.filename
        Loop, Parse, sections, `n, `r
        {
            section := A_LoopField
            IniRead, pairs, % this.filename, % section
            Loop, Parse, pairs, `n, `r
            {
                pair := StrSplit(A_LoopField, "=")
                key := pair[1]
                IniRead, value, % this.filename, % section, % key

                if(value == "false")
                {
                    value := 0
                }
                if(value == "true")
                {
                    value := 1
                }

                if(!this.data.HasKey(section))
                {
                    this.data[section] := {}
                }
                this.data[section][key] := value

                ;record the first section as the main section for later use
                if(!this.mainSection)
                {
                    this.mainSection := section
                }
                MsgBox, % section . "." . key . " = " . value
            }
        }
        ;MsgBox, % this.mainSection
    }

    HasSection(section)
    {
        return this.data.HasKey(section)
    }

    Has(section, key)
    {
        return this.HasSection(section) && this.data[section].HasKey(key)
    }

    GetSection(section)
    {
        if(!this.HasSection(section))
        {
            return {}
        }

        return this.data[section]
    }

    Get(section, key, default)
    {
        if(!this.Has(section, key))
        {
            return default
        }

        return this.data[section][key]
    }

    GetMain(key, default)
    {
        return this.Get(this.mainSection, key, default)
    }

    Set(section, key, value)
    {
        if(!this.HasSection(section))
        {
            this.data[section] = {}
        }

        this.data[section][key] := value
    }

    SetMain(key, value)
    {
        this.Set(this.mainSection, key, value)
    }

    Save()
    {
        ;MsgBox, Ini.Save() not implemented yet!
    }
}