function ska --description "ssh to ska.de and start or enter tmux session called 'admin'"
    ssh -p 22 -t ska "sh -c 'if tmux has -t admin; then tmux attach -t admin; else tmux new -s admin; fi'"
end
