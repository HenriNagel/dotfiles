-- Put this at the top of 'init.lua'
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    -- Uncomment next line to use 'stable' branch
    -- '--branch', 'stable',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
end
-- get os name, Darwin = macOS, Linux = Linus
local os_name = vim.loop.os_uname().sysname

vim.cmd("language en_US")
vim.g.mapleader = ","
vim.g.maplocalleader = ","
-- package manager
require('mini.deps').setup({ path = { package = path_package } })

local add = MiniDeps.add

-- ---------------------------------------------------------------------------------------------------------------------------
add({
  source = 'williamboman/mason.nvim',
})

add({
  source = 'davidgranstrom/scnvim',
})

add({
  source = 'nvim-lua/plenary.nvim'
})

add({
  source = 'nvim-telescope/telescope.nvim'
})

add({
  source = 'williamboman/mason-lspconfig.nvim',
})

add({
  source = 'neovim/nvim-lspconfig',
  -- Supply dependencies near target plugin
  depends = { 'williamboman/mason.nvim' },
})

add({
  source = 'nvim-treesitter/nvim-treesitter',
  -- Use 'master' while monitoring updates in 'main'
  checkout = 'master',
  monitor = 'main',
  -- Perform action after every checkout
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

add({
  source = 'stevearc/oil.nvim',
  depends = { 'echasnovski/mini.icons' },
})

add({
  source = 'lervag/vimtex',
})

add({
  source = 'sirver/ultisnips',
})

add({
  source = 'barreiroleo/ltex_extra.nvim'
})

add({
  source = 'rcarriga/nvim-notify',
})

add({
  source = 'epwalsh/pomo.nvim',
})
-- ---------------------------------------------------------------------------------------------------------------------------

require('mason').setup()
require('mason-lspconfig').setup()

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({
	capabilities = capabilities,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
			},
		},
	},
})

lspconfig.ocamllsp.setup({
	capabilities = capabilities,
})

lspconfig.clangd.setup({
	capabilities = capabilities,
  cmd = { "clangd", "--compile-commands-dir=build" }
})

lspconfig.ltex.setup({
  capabilities = capabilities,
  on_attach = function(client, bufnr)
    require('ltex_extra').setup{
      load_langs = {"en-US"},
    }
  end,
  settings = {
    ltex = {
      language = "en-US",
      diagnosticSeverity = "information",
      hideFalsePositives = true,
      enablePickyRule = true,
    }
  }
})

lspconfig.ols.setup {
	init_options = {
		checker_args = "-strict-style",
		collections = {
			{ name = "shared", path = vim.fn.expand('$HOME/odin-lib') }
		},
	},
}

vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, {})
vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
vim.keymap.set("n", "<leader>gt", vim.lsp.buf.type_definition, {})
vim.keymap.set("n", "<leader>gi", vim.lsp.buf.implementation, {})
vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, {})
vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, {})
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, {})

-- Errors
vim.keymap.set("n", "<leader>of", vim.diagnostic.open_float, {})
vim.keymap.set("n", "<leader>dl", "<cmd>Telescope diagnostics<cr>", {})
vim.keymap.set("n", "g]", vim.diagnostic.goto_next, {})
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev, {})

require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'vimdoc' },
  highlight = { enable = true },
})

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- mini 
require('mini.completion').setup()
require('mini.surround').setup()
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    -- Leader triggers
    { mode = 'n', keys = '<Leader>' },
    { mode = 'x', keys = '<Leader>' },

    -- Built-in completion
    { mode = 'i', keys = '<C-x>' },

    -- `g` key
    { mode = 'n', keys = 'g' },
    { mode = 'x', keys = 'g' },

    -- Marks
    { mode = 'n', keys = "'" },
    { mode = 'n', keys = '`' },
    { mode = 'x', keys = "'" },
    { mode = 'x', keys = '`' },

    -- Registers
    { mode = 'n', keys = '"' },
    { mode = 'x', keys = '"' },
    { mode = 'i', keys = '<C-r>' },
    { mode = 'c', keys = '<C-r>' },

    -- Window commands
    { mode = 'n', keys = '<C-w>' },

    -- `z` key
    { mode = 'n', keys = 'z' },
    { mode = 'x', keys = 'z' },
  },

  clues = {
    -- Enhance this by adding descriptions for <Leader> mapping groups
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
  },
})

require('mini.ai').setup()
require('mini.pairs').setup()
require('mini.indentscope').setup({
  draw = {
    animation = require('mini.indentscope').gen_animation.none()
  },
  symbol = '|',
})
require('mini.visits').setup()

require('oil').setup()
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" }) 

if os_name == "Linux" then
  vim.g.vimtex_view_method = 'zathura'
elseif os_name == "Darwin" then
  vim.g.vimtex_view_method = 'skim'
end

vim.g.vimtex_compiler_latexmk = {
  aux_dir = 'aux',
  out_dir = 'output',
}

vim.g.vimtex_complete_bib = {
  simple = 1,
  menu_fmt = '%t (%k)'
}

vim.o.conceallevel = 1
vim.g.tex_conceal = "g"
-- set conceal color to text color
-- Function to set Conceal to match Normal
local function set_conceal_to_normal()
    -- Get the current colors of the 'Normal' highlight group
    local normal_hl = vim.api.nvim_get_hl(0, { name = "Normal" })

    -- Extract foreground and background colors
    local normal_fg = normal_hl.fg
    local normal_bg = normal_hl.bg

    -- Set the 'Conceal' highlight group with the same colors
    vim.api.nvim_set_hl(0, 'Conceal', { fg = normal_fg, bg = normal_bg })
end

set_conceal_to_normal()

-- Call the function to apply the changes
set_conceal_to_normal()
vim.g.UltiSnipsExpandTrigger = '<tab>'
vim.g.UltiSnipsJumpForwardTrigger = '<tab>'
vim.g.UltiSnipsJumpBackwardTrigger = '<s-tab>'

-- telescope 
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

-- basic vim
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.bo.softtabstop = 2
vim.opt.signcolumn = 'yes'

-- linebreak behaviour
vim.o.linebreak = true
vim.o.wrap = true
vim.o.breakindent = true

-- visual line movement 
-- Remap movement keys to operate on visual lines
local opts = { noremap = true, silent = true }

--notify 
require('notify').setup({
  stages = "fade",
})

--pomo
require('pomo').setup({})

-- supercollider
require('scnvim').setup({})
