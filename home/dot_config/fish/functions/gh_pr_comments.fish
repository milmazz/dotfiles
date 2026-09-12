function gh_pr_comments --description 'List PR comments made by the repo owner' --argument-names repo_owner repo_name pr_number
    if test (count $argv) -ne 3
        echo "Usage: gh_pr_comments <repo_owner> <repo_name> <pr_number>"
        return 1
    end

    gh api \
                -H "Accept: application/vnd.github+json" \
                -H "X-GitHub-Api-Version: 2022-11-28" \
                /repos/$repo_owner/$repo_name/pulls/$pr_number/comments \
                | jq '[.[] | select(.user.type == "User" and .user.login == "'$repo_owner'") | { diff_hunk, line, start_line, body }]'
end
