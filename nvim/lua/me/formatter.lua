require("formatter").setup(
  {
    filetype = {
      sh = {
        -- Shell Script Formatter
        function()
          return {
            exe = "shfmt",
            args = {"-i", 2},
            stdin = true
          }
        end
      },
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      elixir = {
        -- mix
        function()
          return {
            exe = "mix",
            args = {"format", "-"},
            stdin = true
          }
        end
      }
    }
  }
)
