-- module config/utils/spread

local vim = assert(vim)

return function(...)
	return vim.tbl_deep_extend("force", ...)
end
