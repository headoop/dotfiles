function hex2dec --description 'convert hexadecimal to decimal'
    function _help
        echo "usage:"
        echo "$_ <hex number>"
        echo
        echo "example: $_ F"
        echo "output: 15"
        echo
        echo "example $_ 0xF"
        echo "output: 15"
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
    else if echo $argv | egrep '^[[:alnum:]]+$' >/dev/null 2>&1
        set x (string replace -r '^0x' '' $argv)
        set x (string upper $x)
        echo "obase=10;ibase=16;$x" | bc
    else
        echo "not a hex number"
    end
end
