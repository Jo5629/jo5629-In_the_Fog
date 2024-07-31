local storage = minetest.get_mod_storage()
local herobrine_daycount = storage:get_int("herobrine.daycount")

function herobrine.get_daycount()
    return herobrine_daycount
end

function herobrine.set_daycount(num)
    herobrine_daycount = num
    storage:set_int("herobrine.daycount", num)
end

local old_day = minetest.get_day_count()
local function check_daycount()
    local new_day = minetest.get_day_count()
    if new_day ~= old_day then
        herobrine.set_daycount(herobrine_daycount + 1)

        for _, callback in ipairs(herobrine.registered_on_day_change) do
            callback(herobrine_daycount)
        end
        old_day = new_day
    end
    minetest.after(20, check_daycount)
end

minetest.after(0, function()
    old_day = minetest.get_day_count()
    check_daycount()
end)