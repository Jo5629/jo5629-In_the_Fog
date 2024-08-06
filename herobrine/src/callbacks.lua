local function make_registration()
    local t = {}
    local registerfunc = function(func)
        t[#t + 1] = func
    end

    function t:RunCallbacks(stop, ...)
        for _, callback in ipairs(self) do
            if not callback(...) and stop then
                return false
            end
        end
        return true
    end
    return t, registerfunc
end

herobrine.registered_on_day_change, herobrine.register_on_day_change = make_registration()
herobrine.registered_on_spawn, herobrine.register_on_spawn = make_registration()
herobrine.registered_on_despawn, herobrine.register_on_despawn = make_registration()