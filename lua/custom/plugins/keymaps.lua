-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--

-- vim.keymap.set("n","<leader>tr",function() vim.opt.relativenumber = not vim.opt.relativenumber end,{})

local function display_current_file_cflist()
  local workspace_path = vim.lsp.buf.list_workspace_folders()[1]
  local file_path = vim.fn.expand('%:' .. workspace_path .. ':.')
  local command = "Cfilter " .. file_path
  vim.diagnostic.setqflist()
  vim.cmd('packadd cfilter')
  -- print(command)
  vim.cmd(command)
  -- print(file_path)
end

vim.opt.relativenumber = true

vim.opt.wrap = false
vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50
vim.opt.colorcolumn = "80"

vim.keymap.set("v","<M-Up>",":m '<-2<CR>gv=gv")
vim.keymap.set("v","<M-k>",":m '<-2<CR>gv=gv")
vim.keymap.set("v","<M-Down>",":m '>+1<CR>gv=gv")
vim.keymap.set("v","<M-j>",":m '>+1<CR>gv=gv")
vim.keymap.set("n","<leader>e",vim.diagnostic.open_float)
vim.keymap.set("n","<leader>q",display_current_file_cflist)
vim.keymap.set("n","<leader><leader>q",vim.diagnostic.setqflist)

vim.keymap.set("x","<leader>p", "\"_dP")
vim.keymap.set("i","<C-j>", "<Esc>o")
vim.keymap.set("i","<C-Enter>", "<Esc>o")

-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, {desc = 'Open Explorer'})
vim.keymap.set('n', '<leader>p', vim.cmd.Ex, {desc = 'Open Explorer'})


vim.api.nvim_create_autocmd({'Filetype'}, {
  pattern = {"python"},
  callback = function()
    vim.keymap.set('x','<leader>r','yoprint("f{pA=}"')
  end
})

vim.api.nvim_create_autocmd({'Filetype'}, {
  pattern = {"javascript","typescript"},
  callback = function()
    vim.keymap.set('x','<leader>r','yoconsole.log("pA",pA);')
  end
})

return {}
