function bin2hex
    function _help
        echo "usage:"
        echo "$_ <binary number>"
        echo
        echo "example: $_ 1010"
        echo "output: 0xA"
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
        set hex (echo "obase=16;ibase=2;$argv" | bc)
        echo "0x$hex"
    else
        echo "not a binary number"
        _help
    end
end
