-- Replace ElixirLS with dexter (https://github.com/remoteoss/dexter)
--
-- Why: on large Elixir codebases, ElixirLS compiles the whole
-- project and runs Dialyzer. In our setup that was crash-looping
-- (Dialyzer transfer_plt MatchError), re-installing itself, and fighting over
-- the _build lock across git worktrees -- filling lsp.log with ~90MB of errors.
--
-- dexter parses source as text into a SQLite index instead of compiling, so it
-- avoids all of that. Trade-off: no Dialyzer / no compile-error diagnostics.
-- (credo diagnostics from the LazyVim elixir extra still work via nvim-lint.)
--
-- Requires the `dexter` binary on PATH. Installed here via mise:
--   mise use -g aqua:remoteoss/dexter@latest
-- Verify:  dexter version   and   mise which dexter
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- Turn ElixirLS off completely; dexter is the only Elixir LSP now.
        elixirls = { enabled = false },

        -- dexter: fast, full-featured Elixir LSP optimized for big codebases.
        dexter = {
          mason = false, -- not a Mason package; managed by mise
          cmd = { "dexter", "lsp" },
          filetypes = { "elixir", "eelixir", "heex" },
          -- Prefer an existing index, then the project root.
          root_markers = { ".dexter/dexter.db", ".dexter.db", "mix.exs", ".git" },
          init_options = {
            followDelegates = true,
            -- debug = true,        -- verbose logging while evaluating
            -- stdlibPath = "",     -- override Elixir stdlib path if needed
          },
        },
      },
    },
  },
}
