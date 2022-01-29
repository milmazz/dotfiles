local treesitter = require("nvim-treesitter.configs")

treesitter.setup {
  -- Consistent syntax highlighting.
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false
  },
  -- Incremental selection based on the named nodes from the grammar.
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm"
    }
  },
  -- Indentation based on treesitter for the = operator. NOTE: This is an experimental feature.
  indent = {
    enable = true
  },
  ensure_installed = {
    "bash",
    "dockerfile",
    "eex",
    "elixir",
    "erlang",
    "fish",
    "html",
    "json",
    "lua",
    "yaml"
  }
}

vim.cmd([[set foldmethod=expr]])
vim.cmd([[set foldexpr:nvim_treesitter#foldexpr()]])
