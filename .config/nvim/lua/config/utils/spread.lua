-- module config/utils/spread

local vim = assert(vim)
local deepcopy = vim.deepcopy

return function(template, override)
	local splice = function(coverride)
		local result = {}
		setmetatable(result, getmetatable(template))

		for key, value in pairs(template) do
			result[key] = deepcopy(value)
		end

		for key, value in pairs(coverride) do
			result[key] = value
		end

		return result
	end

	return override and splice(override) or splice
end
