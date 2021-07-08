local function scan_right(array, init, op) -- a bit old but works
	local results = {[#array + 1] = init};
	for i = #array, 1, -1 do -- could make an iterator
		local result = op(array[i], results[i + 1] or init);
		results[i] = result;
	end
	return results;
end