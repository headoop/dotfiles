function tart -d 'list archive'

    set -l _my_name (status current-command)

    function usage
        echo "list content of various compreѕsed files"
        echo "usage: $_my_name <compressedfile>"
    end

    if test -z $argv[1] || test $argv[1] = -h
        usage
        return
    end

    if test -f $argv[1]
        set -l _file_lower (string lower $argv[1])
        switch $_file_lower
            case '*.tar.bz2' '*.tbz'
                tar tjf $argv[1]
            case '*.tar.gz' '*.tgz'
                tar tzf $argv[1]
            case '*.tar.xz'
                tar tJf $argv[1]
            case '*.tar'
                tar tf $argv[1]
            case '*.zip'
                unzip -l $argv[1]
            case '*.rar'
                unrar l $argv[1]
            case '*.bz2'
                echo "cannot peek into .bz2"
            case '*.gz' '*.gzip'
                gunzip -l $argv[1]
            case '*.z' '*.Z'
                uncompress -l $argv[1]
            case '*'
                echo "unknown archiv format"
        end
    else
        echo "not a valid file"
    end
end
