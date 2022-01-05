require("formatter").setup(
  {
    filetype = {
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
