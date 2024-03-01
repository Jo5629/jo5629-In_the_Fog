--> Some of the leaves might be cut off.
minetest.register_on_generated(function(minp, maxp, blockseed)
    local vm, emin, emax = minetest.get_mapgen_object("voxelmanip")
    minp, maxp = vm:get_emerged_area() --> Somehow this works but the original minp and maxp do not???

    local a = VoxelArea:new({
        MinEdge = emin,
        MaxEdge = emax,
    })

    local data = vm:get_data()
    for z = minp.z, maxp.z do
        for y = minp.y, maxp.y do
            for x = minp.x, maxp.x do
                local vi = a:index(x, y, z)
                local node_name = minetest.get_name_from_content_id(data[vi])
                if minetest.get_item_group(node_name, "leaves") ~= 0 then
                    data[vi] = minetest.get_content_id("air")
                end
            end
        end
    end

    vm:set_data(data)
    vm:write_to_map(true)
    vm:update_liquids()
    --minetest.log("action","[In the Fog] Tree leaves should be removed.")
end)