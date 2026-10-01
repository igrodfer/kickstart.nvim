return {
  "danymat/neogen",
  config = function()
    local opts = { desc = 'Gen Documentation', noremap = true, silent = true }
    vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
    require('neogen').setup({
      enabled = true,
      languages = {
        python = {
          template = {
            annotation_convention = 'google_docstrings'
          }
        }
      }
    })
  end
}
