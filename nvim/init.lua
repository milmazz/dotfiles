require("plugins")

local cmd = vim.cmd
local opt = vim.opt
local g = vim.g

opt.backspace = {"indent", "eol", "start"}
opt.cursorcolumn = true
opt.cursorline = true
opt.expandtab = true -- Use spaces instead of tabs
opt.hidden = true -- Enable background buffers
opt.hlsearch = true -- Highlight found searches
opt.ignorecase = true -- Ignore case
opt.incsearch = true -- Shows the match while typing
opt.joinspaces = false -- No double spaces with join
opt.linebreak = true -- Stop words being broken on wrap
opt.list = false -- Show some invisible characters
opt.mouse = ""
opt.number = true -- Show line numbers
opt.numberwidth = 5 -- Make the gutter wider by default
opt.relativenumber = true -- Relative line numbers
opt.shiftwidth = 2
opt.smartcase = true
opt.softtabstop = 2
opt.tabstop = 2
opt.title = true

g.mapleader = ","

-- providers
g.python_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim2/bin/python"
g.python3_host_prog = os.getenv("HOME") .. "/.pyenv/versions/neovim3/bin/python"

function map(mode, shortcut, command)
  vim.api.nvim_set_keymap(mode, shortcut, command, {noremap = true, silent = true})
end

-- Configure Neovim to automatically run `:PackerCompile` whenever
-- `plugins.lua` is updated with an autocommand:
vim.cmd(
  [[
augroup packer_user_config
  autocmd!
  autocmd BufWritePost plugins.lua source <afile> | PackerCompile
augroup end
]]
)

----------------
-- Treesitter --
----------------
require("me.treesitter")

-- Color Scheme with Tree-Sitter Support
opt.termguicolors = true
opt.background = "dark" -- or ligth
-- Set contrast.
-- This configuration option should be placed before `colorscheme everforest`.
-- Available values: 'hard', 'medium'(default), 'soft'
g.everforest_background = "soft"
cmd([[colorscheme everforest]])

---------------
-- Telescope --
---------------
require("me.telescope")

-------------
-- lualine --
-------------
require("me.lualine")

---------------
-- Formatter --
---------------
require("me.formatter")

-- Format on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.ex,*.exs,*.js,*.rs,*.lua FormatWrite
augroup END
]],
  true
)

-------------
-- Aliases --
-------------

map("n", "<leader>,", [[:Format<CR>]]) -- Format
--map("n", "<leader>ff", [[<cmd>lua require('telescope.builtin').git_files()<cr>]])
map("n", "<leader>ff", [[<cmd>lua require('telescope.builtin').find_files()<cr>]])
map("n", "<leader>fg", [[<cmd>lua require('telescope.builtin').live_grep()<cr>]])
map("n", "<leader>fb", [[<cmd>lua require('telescope.builtin').buffers()<cr>]])
map("n", "<leader>f?", [[<cmd>lua require('telescope.builtin').help_tags()<cr>]])
map("n", "<leader>fh", [[<cmd>lua require('telescope.builtin').command_history()<cr>]])
map("n", "<leader>ft", [[<cmd>lua require('telescope.builtin').tags()<cr>]])
map("n", "<leader>fq", [[<cmd>lua require('telescope.builtin').quickfix()<cr>]])
map("n", "<leader>fs", [[<cmd>lua require('telescope.builtin').spell_suggest()<cr>]])

map("n", "<leader>tt", [[:TestNearest<CR>]]) -- test this
map("n", "<leader>tf", [[:TestFile<CR>]])
map("n", "<leader>ta", [[:TestSuite<CR>]]) -- test all
map("n", "<leader>tl", [[:TestLast<CR>]])
map("n", "<leader>tv", [[:TestVisit<CR>]])

-----------------------
-- LSP configuration --
-----------------------
-- Add additional capabilities supported by nvim-cmp
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  -- Mappings.
  local opts = {noremap = true, silent = true}

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  buf_set_keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

local lspconfig = require("lspconfig")

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
-- local servers = {"clangd", "rust_analyzer", "pyright", "tsserver"}
--for _, lsp in ipairs(servers) do
--  lspconfig[lsp].setup {
--    -- on_attach = my_custom_on_attach,
--    capabilities = capabilities
--  }
--end
local path_to_elixirls = vim.fn.expand("~/.cache/nvim/lspconfig/elixirls/elixir-ls/release/language_server.sh")

require("lspconfig").elixirls.setup(
  {
    cmd = {path_to_elixirls},
    capabilities = capabilities,
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150
    },
    settings = {
      elixirLS = {
        dialyzerEnabled = true,
        fetchDeps = true
      }
    }
  }
)

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menu,menuone,noselect"

-------------------
-- luasnip setup --
-------------------
local luasnip = require "luasnip"

--------------------
-- nvim-cmp setup --
--------------------
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp = require "cmp"

cmp.setup {
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  mapping = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), {"i", "c"}),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), {"i", "c"}),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), {"i", "c"}),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping(
      {
        i = cmp.mapping.abort(),
        c = cmp.mapping.close()
      }
    ),
    ["<CR>"] = cmp.mapping.confirm({select = true}), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    ["<Tab>"] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end,
      {"i", "s"}
    ),
    ["<S-Tab>"] = cmp.mapping(
      function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          fallback()
        end
      end,
      {"i", "s"}
    )
  },
  sources = cmp.config.sources(
    {
      {name = "nvim_lsp"},
      {name = "luasnip"}
    },
    {
      {name = "buffer"}
    }
  )
}

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  "/",
  {
    sources = {
      {name = "buffer"}
    }
  }
)

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(
  ":",
  {
    sources = cmp.config.sources(
      {
        {name = "path"}
      },
      {
        {name = "cmdline"}
      }
    )
  }
)
