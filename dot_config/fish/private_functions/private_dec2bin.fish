function dec2bin --description 'convert decimal to binary'
    function _help
        echo "usage:"
        echo "$_ <decimal number>"
        echo
        echo "example: $_ 2"
        echo "output: 10"
    end
    set -l options (fish_opt --short=h --long=help)
    argparse --name=bin2dec $options -- $argv
    or return
    if set -q _flag_h; or set -q _flag_help
        _help
        return
    end

    if test -z $argv
        return
    else if echo $argv | egrep '^[[:digit:]]+$' >/dev/null 2>&1
        echo "obase=2;$argv" | bc
    else
        echo "not an integer"
    end
end
