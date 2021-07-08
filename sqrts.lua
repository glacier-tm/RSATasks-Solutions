
local function approx_sqrts(num, approx, bound)
    assert(num > 0, 'only positive number');
    assert(approx > 0, 'only positive approx');
    
    local approxs = { approx };
    repeat
        approx = (approx + (num / approx)) / 2; -- inverse function for num
        table.insert(approxs, approx);
    until (math.abs(num - approx * approx) <= bound);

    return approxs;
end