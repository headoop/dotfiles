function bin2dec
    function _help
        echo "usage:"
        echo "$_ <binary number>"
        echo
        echo "example: $_ 1010"
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
    else if echo $argv | egrep '^[0,1]+$' >/dev/null 2>&1
        echo "obase=10;ibase=2;$argv" | bc
    else
        echo "not a binary number"
        echo
    end
end
