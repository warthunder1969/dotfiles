starship init fish | source

set fish_greeting
set VIRTUAL_ENV_DISABLE_PROMPT "1"
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

## Functions
# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
    end
end

## Aliases
# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles
alias ip="ip -color"
# Common use
alias fix="sudo apt --fix-broken install"
alias fpkg="sudo dpkg --configure -a"
alias fmis="sudo apt update --fix-missing"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias l='dir --color=auto'
alias hw='hwinfo --short'
alias df='duf'
alias x="exit"

# Package Management
alias up='sudo nala upgrade && sudo flatpak update -y && cinnamon-spice-updater --update-all && sudo mintupdate-cli refresh-cache'
alias rf='sudo nala update && nala list --upgradable && flatpak remote-ls --updates'
alias in='sudo nala install'
alias re='sudo nala remove'
alias nk='sudo nala purge'
alias se='nala search'
alias cl='sudo nala autoremove && flatpak uninstall --unused'
alias fin='flatpak install'
alias fre='flatpak remove'
alias fse='flatpak search'

# Dotfiles & Files
alias bs='micro ~/.bashrc'
alias ba='micro ~/.bashrc_aliases'
alias ed='micro'
alias rl='source ~/.bashrc'
alias ef='exec fish'
alias dt='cd ~/Nextcloud/Projects/git/dotfiles/linux'
alias ff="fastfetch"
alias cf="cpufetch"
alias lc="bash $HOME/Nextcloud/Projects/git/dotfiles/linux/scripts/tools/system_age.sh"
alias fs="micro ~/.config/fish/config.fish"
# Other
alias free='free -h'
alias tstat="tailscale status"
alias tcon="tailscale configure"
alias tip="tailscale ip -4"
alias tup="tailscale up || tailscale status"
alias tdo="tailscale down ||  tailscale status"
