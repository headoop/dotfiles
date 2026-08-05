function backup-sims4
    if [ $_distribution = ubuntu ]
        sudo /root/.local/bin/backup-sims4.sh \
            && sudo mount -v /media/JPOP_SIMS4 \
            && sudo rsnapshot -v beta \
            && sudo umount -v /media/JPOP_SIMS4
    end
end
