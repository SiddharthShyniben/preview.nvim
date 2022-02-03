local opt = {
	padding = 5,
	keybindInBuffer = true,
	closeOnLeave = true
}

local function preview(filename)
	local width = vim.api.nvim_get_option('columns')
	local height = vim.api.nvim_get_option('lines')

	vim.api.nvim_command('split ' .. filename)

	local bufnr = vim.api.nvim_get_current_buf()

	vim.api.nvim_open_win(0, true, {
		relative = 'win',
		row = opt.padding,
		col = opt.padding,
		width = width - (opt.padding * 2),
		height = height - (opt.padding * 2),
		border = 'rounded',
		style = 'minimal',
	})
	vim.api.nvim_command('wincmd p | q | wincmd p')

	if opt.keybindInBuffer then
		vim.api.nvim_buf_set_keymap(bufnr, 'n', 'q', ':q<cr>', {})
	end

	if opt.closeOnLeave then
		vim.cmd [[
			autocmd BufLeave <buffer> quit
		]]
	end
end

_G._preview_ = preview

local function init(opts)
	opts = opts or {}
	for k, v in pairs(opts) do opt[k] = v end

	-- doesnt work idk
	-- vim.api.nvim_add_user_command('Preview', previewCommand, {desc = {['-nargs'] = 1, ['-complete'] = 'file'}})
	vim.cmd [[
		command -nargs=1 -complete=file Preview call v:lua._preview_('<args>')
	]]
end

return {
	preview = preview,
	init = init,
}
