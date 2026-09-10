function re --description "Get help on an Elixir module or function"
    iex -e "require IEx.Helpers; IEx.Helpers.h($argv); :erlang.halt" | cat
end
