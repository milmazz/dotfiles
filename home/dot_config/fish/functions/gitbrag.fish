function gitbrag --description "git contribution logs" -a author since
    git log --author="$author" --after=$since --pretty=format:'* %ad %s' --date=short
end
