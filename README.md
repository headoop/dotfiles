# My dotfiles managed with chezmoi

## Which config files are managed with chezmoi?

- bash
- birthday
- dms-clear-clipboard.service
- fish
- hyprland
- jrnl
- kitty
- lazycommit
- lazygit
- neomutt
- niri
- nvim
- starship
- tmux
- todotxt
- yazi
- zsh

## which scripts are managed with chezmoi?

- ~/.local/bin/clean-mutt-cache.sh
- ~/.local/bin/cycle-sink-move-all.sh
- ~/.local/bin/dms-clear-clipboard.sh
- ~/.local/bin/font-list
- ~/.local/bin/git-status.sh
- ~/.local/bin/gpg-tasks.sh
- ~/.local/bin/music.sh
- ~/.local/bin/qemu-create-vm.sh
- ~/.local/bin/rezept-drucken.sh
- ~/.local/bin/rezept-suchen.sh
- ~/.local/bin/win11.sh

## which shell completions are managed with chezmoi?

- ~/.config/zsh/completions/\_rezept-drucken.sh (zsh)
- ~/.local/share/bash-completion/completions/rezept-drucken.sh (bash, plus the
  symlink rd for the alias)

The zsh completions directory is added to `fpath` in ~/.zshrc before `compinit`
runs, otherwise the files are not picked up. Bash sources
/usr/share/bash-completion/bash_completion in ~/.bashrc, which then loads
~/.local/share/bash-completion/completions/ on demand.

## On the new host, install chezmoi and some other needed programs

```bash
sudo pacman -Syu && sudo pacman -S git github-cli openssh chezmoi pass gnupg
```

## Setup gnupg keys on the new host, needed for pass

### On the old host

List your secret keys to find your Key ID (fingerprint/email)

```bash
gpg --list-secret-keys --keyid-format LONG
```

Export your secret key (contains public key too) as ASCII armor and import on
the new host in one go:

```bash
gpg --export-secret-keys --armor YOUR_KEY_ID | ssh NEW_HOST gpg --batch --import
```

Do this for trustdb also:

```bash
gpg --export-ownertrust | ssh NEW_HOST gpg --batch --import-ownertrust
```

### On the new host

Verify the import

```bash
gpg --list-secret-keys
```

The fingerprint of the GPG key is stored directly (in plain text) in the
neomutt config `~/.config/neomutt/mailbox_main_muttrc` as `pgp_default_key`.
A fingerprint is public information, so there is no problem with publishing it.
If you ever switch to a new GPG key, adjust it there.

## Setup github login and chezmoi

If your new host has a graphical environment, generate a ssh key and add it
at <https://github.com/settings/keys> in the web browser.

Else, if you have only terminal access, do the following:
create a login token here: <https://github.com/settings/tokens>
Give it a short expiry date, we only need it to add our ssh key to github.

Generate ssh key, if not already done:

```bash
ssh-keygen
```

Then login to github with a token and set up your ssh login:

```bash
gh auth login
```

Chose "GitHub.com" as host and "SSH" for login. Then chose "Paste an authentication
token" as authentication method. Paste your token. Your ssh key will be uploaded
to github. Delete gh config files, because gh stores the token in plain text there:

```bash
rm -rf ~/.config/gh
```

Then initialize chezmoi:

```bash
chezmoi init git@github.com:$GITHUB_USERNAME/dotfiles.git
```

Replace $GITHUB_USERNAME with your github username.

Setup pass with your GPG key, then restore the pass store from backup or other host.
This ensures, that password templates in other dotfiles can access the passwords.

`~/.password-store` is **not** managed with chezmoi, because this repository is
public on GitHub. You have to restore it by hand:

```bash
pass init YOUR_KEY_ID
scp -r oldhost:.password-store ~/.password-store
```

Then apply all the other dotfiles:

```bash
chezmoi apply
```

Or do it in just one step:

```bash
chezmoi init --apply git@github.com:$GITHUB_USERNAME/dotfiles.git
```

My ~/.zshrc is created from dot_zshrc.tmpl. The template file receives the
Anthropic API key from pass to create the environment variable `ANTHROPIC_API_KEY`.

If ~/.zshrc couldn't be generated because ~/.password-store is restored after .zshrc,
run chezmoi again. This time the pass store is there and the template can be run.

~/.config/fish/config.fish is also created from a template file to add the
anthropic api key.

```bash
chezmoi apply
```

The .bashrc and .zshrc files get their aliases from the same
alias template file .chezmoitemplates/aliases.tmpl. To edit aliases, do it there:

```bash
nvim ~/.local/share/chezmoi/.chezmoitemplates/aliases.tmpl
chezmoi apply
```

or its aliases:

```bash
,a
cma
```

## To be done by hand

- restore ~/.config/birthday/config from bitwarden or from the backup
- restore ~/.password-store from the backup (it is not managed with chezmoi,
  because this repository is public on GitHub)
