function recipe-file-gen --description 'generate file name from recipe name'
    set f (string join "-" $argv)
    set f (string lower $f)
    set f (string replace -a ä ae $f)
    set f (string replace -a ü ue $f)
    set f (string replace -a ö oe $f)
    set f (string replace -a ß ss $f)
    #set f (string replace -a Ä Ae $f)
    #set f (string replace -a Ü Ue $f)
    #set f (string replace -a Ö Oe $f)
    set f (string replace -a , '' $f)
    nvim $HOME/Rezepte/{$f}.txt
end
