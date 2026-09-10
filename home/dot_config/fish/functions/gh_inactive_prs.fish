function gh_inactive_prs --description "List open PRs with no activity in the last N days"
    set -l days 90

    # --repo <owner/repo> is required; --days <N> defaults to 90.
    argparse 'd/days=' 'r/repo=' -- $argv
    if not set -q _flag_repo
        echo "Usage: gh_inactive_prs --repo <owner/repo> [--days <N>]" >&2
        return 1
    end
    set -l repo $_flag_repo
    if set -q _flag_days
        set days $_flag_days
    end

    set -l cutoff (date -v -"$days"d +%Y-%m-%dT%H:%M:%SZ 2>/dev/null; or date -d "$days days ago" +%Y-%m-%dT%H:%M:%SZ)

    echo "Open PRs in $repo with no activity since $cutoff ($days days):"
    echo ""

    gh pr list --repo $repo --state open --limit 1000 --json number,title,updatedAt \
        | jq --arg cutoff "$cutoff" \
            '[.[] | select(.updatedAt < $cutoff)] | sort_by(.updatedAt) | .[] | "#\(.number) — \(.title) (last updated: \(.updatedAt[:10]))"' -r
end
