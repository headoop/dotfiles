function tt --description 'attach session "work" or start it'
    if tmux has -t work
        # echo "found session 'work'"
        # echo "shall i attach to?"
        # echo "press ENTER to attach or CTRL-C to abort"
        # read
        tmux attach -t work
    else
        tmux new -d -s work
        tmux attach -t work
    end
end
