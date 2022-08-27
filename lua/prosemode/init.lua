local M = {}
local keymap = vim.api.nvim_set_keymap
local keydelete = vim.api.nvim_del_keymap
local opt = vim.opt
local cmd = vim.api.nvim_create_user_command

-- lots of reference to https://www.youtube.com/watch?v=n4Lp4cV8YR0&t=1574s
-- please go watch the tutorial for more info

local find_mapping = function(maps, lhs)
	--    iteratres over ONLY numeric keys in a table
	--    order IS guaranteed
	for _, value in ipairs(maps) do
		if value.lhs == lhs then
			return value
		end
	end
end

M.setup = function()
	-- create global variable to store state of prose mode
	vim.g.prose_mode = false
	setup_commands()
end

M._key_stack = {}

M.push_keys = function(name, mode, mappings)
	-- add keymappings for the mode to stack
	local maps = vim.api.nvim_get_keymap(mode)

	local existing_maps = {}
	for lhs, _ in pairs(mappings) do
		local existing = find_mapping(maps, lhs)
		if existing then
			existing_maps[lhs] = existing
		end
	end

	for lhs, rhs in pairs(mappings) do
		keymap(mode, lhs, rhs, { noremap = true, silent = true })
	end

	M._key_stack[name] = M._key_stack[name] or {}

	M._key_stack[name][mode] = {
		existing = existing_maps,
		mappings = mappings,
	}
end

M._opt_stack = {}

M.pop_keys = function(name, mode)
	local state = M._key_stack[name][mode]
	M._key_stack[name][mode] = nil

	for lhs in pairs(state.mappings) do
		if state.existing[lhs] then
			-- Handle mappings that existed
			local og_mapping = state.existing[lhs]

			-- TODO: Handle the options from the table
			keymap(mode, lhs, og_mapping.rhs, { noremap = true, silent = true })
		else
			-- Handled mappings that didn't exist
			keydelete(mode, lhs)
		end
	end
end

M._clear = function()
	M._key_stack = {}
	M._opt_stack = {}
end

M.ProseOn = function()
	M.push_keys("prose", "n", {
		["j"] = "gj",
		["k"] = "gk",
		["0"] = "g0",
		["$"] = "g$",
		["A"] = "g$a",
		["I"] = "g0i",
	})

	-- store the orignal settings (only if they are not already set)
	if next(M._opt_stack) == nil then
		M._opt_stack = {
			["linebreak"] = opt.linebreak:get(),
			["wrap"] = opt.wrap:get(),
			["number"] = opt.number:get(),
			["relativenumber"] = opt.relativenumber:get(),
			["foldcolumn"] = opt.foldcolumn:get(),
		}
	end

	-- change the current settings
	opt.linebreak = true
	opt.wrap = true
	opt.number = false
	opt.relativenumber = false
	opt.foldcolumn = "2"

	vim.g.prose_mode = true
end

M.ProseOff = function()
	-- remove the keymappings we changed
	if next(M._key_stack["prose"]) ~= nil then
		M.pop_keys("prose", "n")
	end

	-- restore the original settings if they were stored
	if next(M._opt_stack) ~= nil then
		opt.linebreak = M._opt_stack["linebreak"]
		opt.wrap = M._opt_stack["wrap"]
		opt.number = M._opt_stack["number"]
		opt.relativenumber = M._opt_stack["relativenumber"]
		opt.foldcolumn = M._opt_stack["foldcolumn"]
	end

	vim.g.prose_mode = false
end

M.ProseToggle = function()
	if vim.g.prose_mode then
		M.ProseOff()
	else
		M.ProseOn()
	end
end

local function setup_commands()
	-- setup nvim commands user can call
	-- based on bufferline
	cmd("ProseToggle", function()
		M.ProseToggle()
	end, {})
	cmd("ProseOn", function()
		M.ProseOn()
	end, {})
	cmd("ProseOff", function()
		M.ProseOff()
	end, {})
end

return M
