
local nmap = function(keys, func, desc)
  if desc then
    desc = 'LSP: ' .. desc
  end

  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end
return {
  'VonHeikemen/lsp-zero.nvim', branch = 'v3.x',
  config = function()

    local lsp_zero = require('lsp-zero')
    lsp_zero.extend_lspconfig()
    -- don't add this function in the `on_attach` callback.
    -- `format_on_save` should run only once, before the language servers are active.
    lsp_zero.format_on_save({
      format_opts = {
	async = false,
	timeout_ms = 10000,
      },
      servers = {
	['tsserver'] = {'javascript', 'typescript'},
	['rust_analyzer'] = {'rust'},
	['prettierd'] = {'python', 'typescript'},
	['sonarlint-language-server'] = {'typescript'},
      }
    })
    lsp_zero.on_attach(function(client, bufnr)
      local opts = {buffer = bufnr, remap = false}

      nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
      nmap('<leader>ca', function()
	vim.lsp.buf.code_action { context = { only = { 'quickfix', 'refactor', 'source' } } }
      end, '[C]ode [A]ction')

      nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')
      nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
      nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
      nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition')
      nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
      nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

      -- See `:help K` for why this keymap
      nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
      nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

      -- Lesser used LSP functionality
      nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
      nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
      nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
      nmap('<leader>wl', function()
	print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, '[W]orkspace [L]ist Folders')
      vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, {desc = 'Hover Documentation'})

      -- Create a command `:Format` local to the LSP buffer
      vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
	vim.lsp.buf.format()
      end, { desc = 'Format current buffer with LSP' })

      -- Diagnostic keymaps
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
      vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

    end)

    -- document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    }
    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
    require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
      ['<leader>h'] = { 'Git [H]unk' },
    }, { mode = 'v' })

    -- Setup neovim lua configuration
    require('neodev').setup()

    -- to learn how to use mason.nvim with lsp-zero
    -- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
    require('mason').setup({})
    require('mason-lspconfig').setup({
      ensure_installed = {'tsserver', 'rust_analyzer','pyright'},
      handlers = {
	lsp_zero.default_setup,
	lua_ls = function()
	  local lua_opts = lsp_zero.nvim_lua_ls()
	  require('lspconfig').lua_ls.setup(lua_opts)
	end,
      }
    });

    -- document existing key chains
    require('which-key').register {
      ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
      ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
      ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
      ['<leader>h'] = { name = 'Git [H]unk', _ = 'which_key_ignore' },
      ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
      ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
      ['<leader>t'] = { name = '[T]oggle', _ = 'which_key_ignore' },
      ['<leader>w'] = { name = '[W]orkspace', _ = 'which_key_ignore' },
    }
    -- register which-key VISUAL mode
    -- required for visual <leader>hs (hunk stage) to work
    require('which-key').register({
      ['<leader>'] = { name = 'VISUAL <leader>' },
      ['<leader>h'] = { 'Git [H]unk' },
    }, { mode = 'v' })
    local cmp = require('cmp')
    local cmp_select = {behavior = cmp.SelectBehavior.Select}

    -- [[ Configure nvim-cmp ]]
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
    require('luasnip.loaders.from_vscode').lazy_load()
    luasnip.config.setup {}

    -- this is the function that loads the extra snippets to luasnip
    -- from rafamadriz/friendly-snippets
    require('luasnip.loaders.from_vscode').lazy_load()

    cmp.setup({
      sources = {
	{name = 'path'},
	{name = 'nvim_lsp'},
	{name = 'nvim_lua'},
	{name = 'luasnip', keyword_length = 2},
	{name = 'buffer', keyword_length = 3},
      },
      formatting = lsp_zero.cmp_format(),
      mapping = cmp.mapping.preset.insert({
	['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
	['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
	['<C-y>'] = cmp.mapping.confirm({ select = true }),
	['<C-Space>'] = cmp.mapping.complete(),
	['<CR>'] = cmp.mapping.confirm {
	  behavior = cmp.ConfirmBehavior.Replace,
	  select = true,
	},
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
}
