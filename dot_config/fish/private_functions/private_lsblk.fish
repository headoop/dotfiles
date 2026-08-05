function lsblk --description 'alias lsblk=lsblk -o name,size,mountpoint,fstype,label,uuid,model'
    command lsblk -o name,size,mountpoint,fstype,label,uuid,model $argv

end
