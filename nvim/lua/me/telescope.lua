require("telescope").setup {
  defaults = {
    preview = {
      -- NOTE: Disabling this for performance purposes for now
      -- See: https://github.com/nvim-telescope/telescope.nvim/issues/1616#issuecomment-999123921
      -- Apparently was fixed, let's see.
      treesitter = true
    }
  },
  extensions = {
    fzf = {
      fuzzy = true, -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true, -- override the file sorter
      case_mode = "smart_case" -- or "ignore_case" or "respect_case"
      -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension:
require("telescope").load_extension("fzf")
