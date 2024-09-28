local storage = minetest.get_mod_storage()
local herobrine_daycount = storage:get_int("herobrine.daycount")

function herobrine.get_day_count()
    return herobrine_daycount
end

function herobrine.set_day_count(num)
    herobrine_daycount = num
    storage:set_int("herobrine.daycount", num)

    herobrine.registered_on_day_change:RunCallbacks(false, herobrine_daycount)
end

local old_day = minetest.get_day_count()
local function check_daycount()
    local new_day = minetest.get_day_count()
    if new_day ~= old_day then
        herobrine.set_day_count(herobrine_daycount + 1)
        old_day = new_day
    end
    minetest.after(4, check_daycount)
end

minetest.after(0, function()
    minetest.log("action", "[In the Fog] Internal daycount on server startup: " .. tostring(herobrine.get_day_count()))
    old_day = minetest.get_day_count()
    check_daycount()
end)