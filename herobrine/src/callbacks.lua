local function make_registration()
    local t = {}
    local registerfunc = function(func)
        t[#t + 1] = func
    end
    return t, registerfunc
end

herobrine.registered_on_day_change, herobrine.register_on_day_change = make_registration()
herobrine.registered_on_spawn, herobrine.register_on_spawn = make_registration()