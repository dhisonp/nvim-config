vim.pack.add({
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/folke/which-key.nvim',
  'https://github.com/rebelot/kanagawa.nvim',
  'https://github.com/Mofiqul/adwaita.nvim',
})

-- TODO: Review performance
vim.api.nvim_create_autocmd('VimEnter', {
  once = true,
  callback = function()
    vim.schedule(function()
      local inactive = vim
        .iter(vim.pack.get())
        :filter(function(p)
          return not p.active
        end)
        :map(function(p)
          return p.spec.name
        end)
        :totable()
      if #inactive > 0 then
        vim.pack.del(inactive)
        vim.notify('vim.pack: removed ' .. table.concat(inactive, ', '), vim.log.levels.INFO)
      end
    end)
  end,
})

vim.cmd.colorscheme 'kanagawa'

vim.schedule(function()
  require('nvim-treesitter').install({
    'bash',
    'css',
    'diff',
    'dockerfile',
    'gitcommit',
    'html',
    'javascript',
    'json',
    'lua',
    'markdown',
    'markdown_inline',
    'python',
    'query',
    'rust',
    'toml',
    'tsx',
    'typescript',
    'vim',
    'vimdoc',
    'yaml',
    'zig',
  })

  -- Allow vertical split on widths >= 124
  local fzf = require 'fzf-lua'
  fzf.setup({
    winopts = {
      height = 0.85,
      width = 0.80,
      preview = {
        scrollbar = false,
        flip_columns = 88,
      },
    },
  })
  fzf.register_ui_select()

  require('gitsigns').setup()

  local prettier = { 'prettier' }
  require('conform').setup({
    formatters_by_ft = {
      css = prettier,
      html = prettier,
      javascript = prettier,
      javascriptreact = prettier,
      json = prettier,
      lua = { 'stylua' },
      markdown = prettier,
      python = { 'ruff_organize_imports', 'ruff_format' },
      rust = { 'rustfmt' },
      sh = { 'shfmt' },
      toml = { 'taplo' },
      typescript = prettier,
      typescriptreact = prettier,
      yaml = prettier,
      zig = { 'zigfmt' },
    },
  })

  require('which-key').setup({
    preset = 'helix',
    icons = {
      mappings = false,
    },
  })

  vim.api.nvim_create_user_command('Fmt', function()
    require('conform').format({ async = true })
  end, {})
end)
