function tw --description 'start or attach tmux session named "work"'
    if tmux has -t work
        tmux attach -t work
    else
        tmux new -s work
    end
end
