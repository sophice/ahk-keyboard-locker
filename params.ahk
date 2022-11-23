class CommandLineParams
{
    static indexed := []
    static parsed := {}
    static prefixed := {}
    static extras := []
    static loaded := false

    Load()
    {
        if !this.loaded
        {
            previous := null
            for index, param in A_Args
            {
                ;build an indexed array of params for this.index() and this.indexed()
                this.indexed[] := param

                ;if this is not an option, then it's either a value for the previous option, or an "extra" string
                if !Str.startsWith("-") && !Str.startsWith("/")
                {
                    if isset(previous)
                    {
                        this.params[previous] := param
                        previous := null
                    } else {
                        this.extras[] := param
                    }
                    continue
                }

                ;split the string in to key and value. if there is no equals, set value to boolean true

                ;remove dashes from the front
                param := Str.ltrim(param, "-")
                if Str.length(param) == 1
                {
                    ;if param is 1 char, set this.params[param] := true
                }
                ;else split param on equals, set this.params[left] := right
            }

            this.loaded := true
        }
    }

    All()
    {
        static params := Object()
        static parsed := false
        if !parsed
        {
            for index, param in A_Args
            {
                ;if no dashes, set the value of param to the previous (for "-x abc") then continue to next loop
                ;remove dashes from the front
                ;if param is 1 char, set params[param] := true
                ;else split param on equals, set the params[left] := right
            }
        }

        return params
    }

    Has(key)
    {
        params = this.All()
        if params[key] is set
        {
            return true
        }

        return false
    }

    Flag(key)
    {
        return this.Has(key)
    }

    Value(key, default:=false)
    {
        if !this.Has(key)
        {
            return default
        }

        return this.All()[key]
    }
}