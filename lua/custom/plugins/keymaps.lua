-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
--

-- vim.keymap.set("n","<leader>tr",function() vim.opt.relativenumber = not vim.opt.relativenumber end,{})


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

vim.keymap.set("x","<leader>p", "\"_dP")
vim.keymap.set("i","<C-j>", "<Esc>o")
vim.keymap.set("i","<C-Enter>", "<Esc>o")

-- vim.keymap.set('n', '<leader>pv', vim.cmd.Ex, {desc = 'Open Explorer'})
vim.keymap.set('n', '<leader>p', vim.cmd.Ex, {desc = 'Open Explorer'})

return {}
