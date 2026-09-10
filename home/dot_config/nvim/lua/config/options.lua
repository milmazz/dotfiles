-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable unused remote-plugin providers. We don't use any remote (RPC) plugins,
-- so skip the host probes -- this silences the :checkhealth vim.provider warnings
-- and avoids the startup cost of looking for these interpreters.
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
