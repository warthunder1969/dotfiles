source /usr/share/cachyos-fish-config/cachyos-config.fish
starship init fish | source
# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth

## Aliases
# Common use
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias l='dir --color=auto'
alias hw='hwinfo --short'
alias df='duf'
alias x="exit"

# Package Management
alias up='sudo pacman -Syu && yay && sudo flatpak update -y'
alias rf='sudo pacman -Sy && flatpak remote-ls --updates'
alias in='sudo pacman -S'
alias re='sudo pacman -R'
alias se='sudo pacman -Ss'
alias in='yay -R'
alias yse='yay -Ss'
alias yin='yay -S'
alias cl='sudo pacman -Rns $(pacman -Qtdq) && flatpak uninstall --unused'
alias fin='flatpak install'
alias fre='flatpak remove'
alias fse='flatpak search'

# Dotfiles & Files
alias bs='micro ~/.config/fish/config.fish'
alias ba='micro ~/.config/fish/config.fish'
alias ed='micro'
alias rl='source ~/.config/fish/config.fish'
alias dt='cd ~/Nextcloud/Projects/git/dotfiles/linux'
alias ff="fastfetch"
alias cf="cpufetch"
alias lc="bash $HOME/Nextcloud/Projects/git/dotfiles/linux/scripts/tools/system_age.sh"
# Other
alias free='free -h'
alias tstat="tailscale status"
alias tcon="tailscale configure"
alias tip="tailscale ip -4"
alias tup="tailscale up || tailscale status"
alias tdo="tailscale down ||  tailscale status"

#end
