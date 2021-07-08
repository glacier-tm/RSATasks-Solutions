local function slide_array(array, width, step) -- kinda old but good too
    local results = { };

    for i = 1, #array, step do
        local partition = { unpack(array, i, i + width - 1) };
        if (#partition % width == 0) then -- continue = ugly
            results[((i - 1) / step) + 1] = partition;
        end
    end

    return results;
end