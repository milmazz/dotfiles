function gwt --description "Create a git worktree with a new branch"
    if test (count $argv) -ne 2
        echo "Usage: gwt <branch-type> <branch-description>"
        echo "Branch types: chore, bugfix, hotfix, feat"
        return 1
    end

    set branch_type $argv[1]
    set branch_desc $argv[2]

    if not contains $branch_type chore bugfix hotfix feat
        echo "Error: invalid branch type '$branch_type'"
        echo "Allowed types: chore, bugfix, hotfix, feat"
        return 1
    end

    set project_name (basename (git rev-parse --show-toplevel 2>/dev/null))

    if test -z "$project_name"
        echo "Error: not inside a git repository"
        return 1
    end

    git worktree add -b milton/$branch_type/$branch_desc ../$project_name-$branch_desc
    cd ../$project_name-$branch_desc
end
