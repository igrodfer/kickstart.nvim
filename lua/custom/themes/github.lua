return {
  'projekt0n/github-nvim-theme',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'github_light_colorblind'
    vim.api.nvim_set_hl(0, '@function.method.call.typescript', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.type.member.typescript', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.method.public.java', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.method.private.java', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.method.protected.java', { link = 'Function' })
    vim.api.nvim_set_hl(0, '@lsp.type.class.java', { link = 'Type' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.class.public.java', { link = 'Type' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.class.private.java', { link = 'Type' })
    vim.api.nvim_set_hl(0, '@lsp.typemod.class.protected.java', { link = 'Type' })
  end,
}
