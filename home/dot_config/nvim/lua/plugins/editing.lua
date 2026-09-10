-- Editing niceties, tuned for Elixir (which has no brace pairs and tends
-- toward long modules).
-- Note: the treesitter-context *extra* lives in lazyvim.json (extras must be
-- imported before your own plugins, so they don't belong in this folder).
return {
  -- vim-matchup: make `%` jump between block keywords (do/end, case, cond, fn,
  -- if, unless, receive, try...) and add i%/a% text objects. Stock `%` only
  -- knows brackets, which Elixir barely uses.
  {
    "andymass/vim-matchup",
    event = "BufReadPost",
    init = function()
      -- Show the matching keyword in a popup when it's off-screen.
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
}
