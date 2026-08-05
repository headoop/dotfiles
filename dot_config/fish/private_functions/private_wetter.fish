function wetter --description 'get weather forecast from wttr.in/'

    # usage:
    # -l | --lang   set output language (de, fr, en etc.)
    # -p | --place  set location (Berlin, Moskau, HAM etc.)
    #
    # both options require a parameter, else you get an an error message

    # the name used by argparse
    set -l _name (status current-command)
    # the default language if not set with -l/--lang
    set -l _default_lang de
    # the dafaul location if not set with -p/--place
    set -l _default_place Hamburg

    # todo: add help for this function
    # todo: add option n (n narrow verson, only day and night)
    # todo: add option s (0 only current weather)

    argparse --name=$_name 'p/place=' 'l/lang=' -- $argv
    or return

    while true
        if set -q _flag_p
            # echo debug: \$_flag_p: $_flag_p
            # bail out when param starts with a '-'
            # this happens when a required param was not given and the
            # next option is taken as param
            if string match -q -r '^-' -- $_flag_p
                echo "not a valid parameter for option -p/--place: $_flag_p"
                return 3
            else
                # set location
                set _args $_flag_p
            end
        else
            # set default location if not set by option -p/--place
            set _args $_default_place
        end
        if set -q _flag_l
            # echo debug: \$_flag_l: $_flag_l
            # bail out when param starts with a '-'
            # this happens when a required param was not given and the
            # next option is taken as param
            if string match -q -r '^-' -- $_flag_l
                echo "not a valid parameter for option -l/--lang: $_flag_l"
                return 3
            else
                # concatenate param -p/--place and -l/--lang for use in url
                # string
                set _args (string join '' $_args "?lang=" $_flag_l)
            end
        else
            # set lang to $_default_lang when -l/--lang is not used
            set _args (string join '' $_args "?lang=" $_default_lang)
        end
        break
    end

    # echo debug: $_args
    if not test -z $argv
        echo "non-option parameter found: $argv"
        return 4
    end

    # echo debug: "command curl http://wttr.in/$_args"
    command curl http://wttr.in/$_args
end
