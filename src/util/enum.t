local function Enum(...)
	local t = { type = int }
	for i, name in ipairs {...} do
		-- make 0-based to match C++
		t[name] = i - 1
	end
	return t
end

return Enum