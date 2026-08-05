function user-add --description "add a test user"
    set name $argv[1]
    if ! test -z $name
        if id $name &>/dev/null
            echo 'user exists'
        else
            sudo useradd -m $name
            sudo passwd $name
        end
    end
end
