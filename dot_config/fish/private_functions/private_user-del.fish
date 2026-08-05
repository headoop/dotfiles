function user-del --description "delete a user and it's home dir"
    set name $argv[1]
    if ! test -z $name
        if id $name &>/dev/null
            sudo userdel -r $name
        else
            echo 'user not found'
        end
    end
end
