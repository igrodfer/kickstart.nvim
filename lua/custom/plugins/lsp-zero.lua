-- LSP stack migrated from the original configuration. All original packages
-- remain explicit; only their loading order and Neovim 0.12 API are updated.
local servers = { 'lua_ls', 'pyright', 'rust_analyzer', 'ts_ls' }

local function setup_lsp()
  -- lsp-zero v3 still provides the keymaps and completion format. Its server
  -- wrapper calls lspconfig's retired API, so Neovim 0.12 registers servers.
  vim.g.lsp_zero_extend_lspconfig = 0
  local lsp_zero = require('lsp-zero')

  lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    local function map(keys, action, desc)
      vim.keymap.set('n', keys, action, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end
    map('<leader>rn', vim.lsp.buf.rename, 'Rename')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code action')
    map('gd', require('telescope.builtin').lsp_definitions, 'Definition')
    map('gr', require('telescope.builtin').lsp_references, 'References')
    map('gI', require('telescope.builtin').lsp_implementations, 'Implementation')
    map('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type definition')
    map('<leader>ds', require('telescope.builtin').lsp_document_symbols, 'Document symbols')
    map('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace symbols')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('<C-k>', vim.lsp.buf.signature_help, 'Signature help')
    map('gD', vim.lsp.buf.declaration, 'Declaration')
    map('<leader>wa', vim.lsp.buf.add_workspace_folder, 'Add workspace folder')
    map('<leader>wr', vim.lsp.buf.remove_workspace_folder, 'Remove workspace folder')
    map('<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, 'List workspace folders')
    vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature help' })
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function()
      vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
  end)

  vim.lsp.config('lua_ls', {
    settings = { Lua = { diagnostics = { globals = { 'vim' } } } },
  })
  for _, server in ipairs({ 'pyright', 'rust_analyzer', 'ts_ls' }) do
    vim.lsp.config(server, {})
  end
  vim.lsp.enable(servers)

  local cmp = require('cmp')
  local luasnip = require('luasnip')
  require('luasnip.loaders.from_vscode').lazy_load()
  luasnip.config.setup({})
  cmp.setup({
    formatting = lsp_zero.cmp_format(),
    sources = {
      { name = 'path' },
      { name = 'nvim_lsp' },
      { name = 'nvim_lua' },
      { name = 'luasnip', keyword_length = 2 },
      { name = 'buffer', keyword_length = 3 },
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-p>'] = cmp.mapping.select_prev_item(),
      ['<C-n>'] = cmp.mapping.select_next_item(),
      ['<C-y>'] = cmp.mapping.confirm({ select = true }),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<CR>'] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_locally_jumpable() then
          luasnip.expand_or_jump()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.locally_jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
  })
end

return {
  { 'williamboman/mason.nvim', opts = {} },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
      'folke/neodev.nvim',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'rafamadriz/friendly-snippets',
    },
    config = setup_lsp,
  },
  {
    'williamboman/mason-lspconfig.nvim',
    dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
    opts = { ensure_installed = servers, automatic_enable = false },
  },
  {
    'nvimtools/none-ls.nvim',
    config = function()
      require('null-ls').setup({})
    end,
  },
  {
    'jay-babu/mason-null-ls.nvim',
    dependencies = { 'williamboman/mason.nvim', 'nvimtools/none-ls.nvim' },
    opts = {
      ensure_installed = { 'stylua', 'prettierd' },
      automatic_installation = true,
    },
  },
  { 'mfussenegger/nvim-dap' },
  {
    'rcarriga/nvim-dap-ui',
    dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' },
    opts = {},
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    dependencies = { 'williamboman/mason.nvim', 'mfussenegger/nvim-dap' },
    opts = { ensure_installed = { 'python' }, automatic_installation = true },
  },
  {
    'nvim-java/nvim-java',
    ft = { 'java' },
    dependencies = {
      'JavaHello/spring-boot.nvim',
      'MunifTanjim/nui.nvim',
      'neovim/nvim-lspconfig',
      'mfussenegger/nvim-dap',
      'williamboman/mason.nvim',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      require('java').setup({ spring_boot_tools = { enable = true } })
      local spring_util = require('spring_boot.util')
      spring_util.execute_command = function(client, command, param, callback)
        local co
        if not callback then
          co = coroutine.running()
          if co then
            callback = function(err, response)
              coroutine.resume(co, err, response)
            end
          end
        end
        client:request('workspace/executeCommand', {
          command = command,
          arguments = param,
        }, callback)
        if co then
          return coroutine.yield()
        end
      end

      local settings_file = vim.fs.find('docker/settings.xml', {
        path = vim.api.nvim_buf_get_name(0),
        upward = true,
      })[1]
      if settings_file then
        vim.lsp.config('jdtls', {
          settings = {
            java = {
              configuration = {
                maven = { userSettings = settings_file },
              },
            },
          },
        })
      end
      vim.lsp.enable('jdtls')
    end,
  },
}
