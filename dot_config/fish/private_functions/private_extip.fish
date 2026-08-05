function extip --description 'alias extip=dig +short myip.opendns.com @resolver1.opendns.com'
    dig +short myip.opendns.com @resolver1.opendns.com $argv

end
