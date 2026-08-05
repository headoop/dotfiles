# function llB -d "Show size in bytes"
#     if git rev-parse --is-inside-work-tree &>/dev/null
#         eza $EZA_STANDARD_OPTIONS {$EZA_LL_OPTIONS} --git --bytes $argv
#     else
#         eza $EZA_STANDARD_OPTIONS {$EZA_LL_OPTIONS} --bytes $argv
#     end
# end
function llb --wraps='eza_git $EZA_LL_OPTIONS' --description 'alias llb eza_git $EZA_LL_OPTIONS --bytes'
    eza_git $EZA_LL_OPTIONS --bytes
end
