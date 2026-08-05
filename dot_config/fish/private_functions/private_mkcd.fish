function mkcd -d "Create a directory and cd into"

    # give all options and params to mkdir.
    # When mkdir returns 0, test if last option
    # is a dir, then cd into.
    # When multiple dirs have been created, the last
    # created dir will be entered.

    command mkdir $argv
    if test $status = 0
        and if test -d $argv[(count $argv)]
            cd $argv[(count $argv)]
        end
    end
end
