function ls --wraps='eza --icons=auto --color=auto --group-directories-first' --description 'alias ls=eza --icons=auto --color=auto'
    eza --icons=auto --color=auto --group-directories-first $argv
end
