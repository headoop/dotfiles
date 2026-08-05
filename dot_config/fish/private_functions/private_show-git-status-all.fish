function show-git-status-all --description 'show git status of all repos in ~/git/'
    for i in $HOME/git/*
        if test -d $i
            cd $i
            git status >/dev/null 2>&1
            if test $status -ne 128
                basename (git rev-parse --show-toplevel)
                git status -s -b -uall --show-stash
                echo
            end
            cd
        end
    end
end
