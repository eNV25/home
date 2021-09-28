local filetype = {}

filetype[''] = function(file) end

filetype['.py'] = function(file)
	vis:command[[
	set tabwidth 4
	set expandtab on
	]]
end

filetype['.lua'] = function(file)
	vis:command[[
	set tabwidth 4
	set expandtab on
	]]
end

return filetype
