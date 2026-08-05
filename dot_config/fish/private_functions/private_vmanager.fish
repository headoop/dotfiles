function vmanager --description "ssh to vmanager6445 and start or enter tmux session called 'vmanager'"
    ssh -t vmanager6445 "sh -c 'if tmux has -t vmanager; then tmux attach -t vmanager; else tmux new -s vmanager; fi'"
end
