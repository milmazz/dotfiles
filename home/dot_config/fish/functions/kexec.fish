function kexec --wrap="kubectl" --description "Open a bash shell in a pod in the backend namespace"
    kubectl exec -i -t -n backend $argv -- /bin/bash
end
