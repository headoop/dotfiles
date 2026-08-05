function remote-login-tmux --description "ssh to $argv[1] and start or enter tmux session called 'work'"
    ssh -t $argv[1] "sh -c 'if tmux has -t work; then tmux attach -t work; else tmux new -s work; fi'"
end
