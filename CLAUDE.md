# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Repository purpose

This is a personal dotfiles repository managed with
[chezmoi](https://www.chezmoi.io/). The source of truth for a user's home
directory lives here as chezmoi-encoded files/templates; `chezmoi apply`
renders them into `~`. There is no build step, package, or test suite — changes
are verified by applying them to the live system and using the shell/tool in
question.

## Common commands

```bash
chezmoi diff                          # preview what would change before applying
chezmoi apply                         # render templates and apply to $HOME
chezmoi edit --apply <path-in-home>   # edit the source file for a target and
                                      # apply immediately
chezmoi status                        # show pending changes
```

Shorthand aliases for the above are defined in `.chezmoitemplates/aliases.tmpl`
(e.g. `cma` = `chezmoi apply`, `cmd` = `chezmoi diff`, `cme`/`cmea` = `chezmoi
edit`). Per-file quick-edit aliases also exist: `,a` (aliases template itself),
`,b` (~/.bashrc), `,f` (fish config.fish), `,h` (hyprland.conf), `,k`
(kitty.conf), `,z` (~/.zshrc) — all use `chezmoi edit --apply`.

Shell scripts in this repo are linted with shellcheck; repo-wide suppressions
live in `.shellcheckrc` (`SC1054,SC1073,SC1083,SC1009` — these relate to
shellcheck misparsing chezmoi template syntax like `{{ }}`, not real script
issues).

## chezmoi source-file naming (critical for editing correctly)

File/directory names under this repo are chezmoi's _source_ names, not the
literal target names. Key prefixes/suffixes used throughout this repo:

- `dot_` → target starts with `.` (e.g. `dot_zshrc.tmpl` → `~/.zshrc`,
  `dot_config/` → `~/.config/`)
- `private_` → target file gets mode 0600 (used for anything containing secrets
  or credentials, e.g. `private_dot_password-store/`,
  `dot_config/private_starship.toml`,
  `dot_config/lazycommit/private_config.yaml`)
- `executable_` → target file gets the executable bit (all scripts in `dot_local/bin/`)
- `.tmpl` suffix → file is a Go-template rendered by chezmoi at apply time
  (templates can call `pass "NAME"` to pull secrets,
  or `{{ template "name.tmpl" . }}` to include a `.chezmoitemplates/*` partial)
- Files/dirs ending in `~` are editor backups and are excluded via
  `.chezmoiignore` — don't treat them as real source files, and don't bother
  cleaning them up as part of unrelated edits unless asked.

When asked to "edit `~/.zshrc`" or similar, map the target path back to its
`dot_*`/`private_*`/`executable_*` source name under this repo — never assume a
1:1 filename match.

## Secrets

Secrets (API keys, mail passwords, GPG-related config) are never stored in
plaintext in this repo. They are stored in the `pass` password store
(`private_dot_password-store/`, itself chezmoi-managed and GPG-encrypted) and
pulled into rendered files via the `pass` template function, e.g.:

```
export ANTHROPIC_API_KEY="{{ pass "ANTHROPIC_API_KEY" }}"
```

See `dot_zshrc.tmpl`, `dot_bashrc.tmpl`, and
`dot_config/neomutt/mailbox_main_muttrc.tmpl` for examples. Never hardcode a
credential in a template as a replacement for a `pass` lookup.

## Shared templates (`.chezmoitemplates/`)

Logic shared across multiple rendered files lives in `.chezmoitemplates/*.tmpl`
and is pulled in with `{{ template "name.tmpl" . }}`:

- `aliases.tmpl` — the single source of shell aliases, included by both
  `dot_bashrc.tmpl` and `dot_zshrc.tmpl`. **Edit aliases only here**, never
  duplicate an alias directly into `dot_bashrc.tmpl`/`dot_zshrc.tmpl`, or bash
  and zsh will drift apart.

## Managed components

The README (`README.md`) lists which tools have config managed here (bash,
fish, zsh, nvim, kitty, neomutt, tmux, yazi, hyprland, starship, jrnl, todotxt,
birthday, niri, DankMaterialShell) and which scripts under `~/.local/bin/`.
Keep that list in sync if you add or remove a chezmoi-managed target — it's the
map a human uses to find things, not something derivable from a single file.

## New-host bootstrap flow (for context, not something to re-implement)

`README.md` documents the full flow for provisioning a new machine: install
chezmoi, pass and gnupg, transfer the GPG secret key + ownertrust to the new
host, set up GitHub SSH auth, `pass init`, restore `.password-store` first from
backup/other host, then `chezmoi apply` for everything else (a second `apply`
may be needed since templates depending on `pass` can't render until the
password store exists). Keep this doc in sync if the bootstrap steps in this
repo change.
