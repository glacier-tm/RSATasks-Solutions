local minimum_distance;
do
    local math_floor = math.floor;

    -- time complexity avg case : O(n*logn)
    function minimum_distance(points) -- wanted to divide and conquer before but..
        local smallest = 2 ^ 1024; -- a magic number for the maximum number that can be.
        local n_points = #points;

        for i = 1, n_points do
            local j = n_points;
            while (j > 0 and i ~= j) do
                local r_min = (points[i] - points[j]).magnitude;
                if (r_min < smallest) then
                    smallest = r_min;
                    break;
                end
                j = math_floor(j / 2);
            end
        end

        return smallest;
    end
end
