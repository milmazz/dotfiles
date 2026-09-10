function to_rtf --wrap="pygmentize" --description "export syntax-highlighted code to RTF on the clipboard"
    pygmentize -f rtf -O "style=friendly,fontface=Cascadia Code" "$argv" | pbcopy
end
