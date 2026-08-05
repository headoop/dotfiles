# a fish shell function to create a centralized git
# repository on my server and then clone it to the
# working directory

function git-new-central-repo --description 'create bare git repo at devmem.de and clone it'

    # set remote host name and the path where the
    # centralized repo shall live
    set host devmem.de
    set host_dir /srv/git/

    # first argument should be the repo name,
    # further arguments are thrown away
    set repo $argv[1]

    # print help if no argument is given
    if [ -z $repo ]
        echo
        echo create remote bare repository at $host$host_dir
        echo
        echo usage:
        echo
        echo "$_ <repository>[.git]"
        echo
        return
    end

    # if repo name ends with .GIT, make it lowercase
    if string match -q -r '\.GIT$' $repo
        set repo_git (string replace -r '\.GIT$' '.git' $repo)
        set repo (string replace -r '\.GIT$' '' $repo)
        # if repo name does not end with .git, add .git to it
    else if not string match -q -r '\.git$' $repo
        set repo_git $repo.git
        # if $repo has suffix .git
    else
        set repo_git $repo
        set repo (string replace -r '\.git$' '' $repo)
    end

    # do nothing if repo dir exists in working directory
    if test -e $repo; or test -e $repo_git
        echo $repo or $repo_git already exists in working directory
    else
        # create repo and copy it to remote host if it does
        # not already exist there
        #
        # test connection to remote host
        if ssh devmem.de sh -c "'exit'"
            # test if repo exists on remote host
            if not ssh $host sh -c "'test -e /srv/git/$repo_git'"
                git init --bare --shared=group $repo_git
                scp -r $repo_git $host:$host_dir
                rm -rf $repo_git
                git clone ssh://$host$host_dir$repo_git
                cd $repo
                echo
                git remote show origin
                echo -e \n
                git status
                echo -e \n
                ls
                echo
            else
                echo $host has $repo_git
            end # remote repo test
        else
            echo error connecting to $host
        end # remote connection test
    end # local test
end # function
