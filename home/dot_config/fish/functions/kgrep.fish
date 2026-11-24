function kgrep --wrap="kubectl" --description "List pod names in the backend namespace matching a pattern"
    kubectl get pods -n backend | grep $argv | cut -f 1 -d " "
end
