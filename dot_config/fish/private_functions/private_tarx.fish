function tarx -d 'extract archive'

    set -l _my_name (status current-command)

    function usage
        echo "extract content of various compreѕsed files"
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
                tar xjf $argv[1]
            case '*.tar.gz' '*.tgz'
                tar xzf $argv[1]
            case '*.tar.xz'
                tar xJf $argv[1]
            case '*.tar'
                tar xf $argv[1]
            case '*.zip'
                unzip $argv[1]
            case '*.rar'
                unrar $argv[1]
            case '*.bz2'
                bunzip2 $argv[1]
            case '*.gz' '*.gzip'
                gunzip $argv[1]
            case '*.z' '*.Z'
                uncompress $argv[1]
            case '*' echo "unknown archiv format"
        end
    else
        echo "not a valid file"
    end
end
