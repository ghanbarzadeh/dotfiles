# Windows key repeat delay

```sh
Set-Location "HKCU:\Control Panel\Accessibility\Keyboard Response"

Set-ItemProperty -Path . -Name AutoRepeatDelay       -Value 200
Set-ItemProperty -Path . -Name AutoRepeatRate        -Value 30
Set-ItemProperty -Path . -Name BounceTime            -Value 0
Set-ItemProperty -Path . -Name DelayBeforeAcceptance -Value 0
Set-ItemProperty -Path . -Name Flags                 -Value 63
```

# Oh My Zsh

```sh
sudo apt install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

Change "~/.oh-my-zsh/themes/robbyrussell.zsh-theme" to:
```sh
PROMPT="%(?:%{$fg_bold[green]%}%1{➜%} :%{$fg_bold[red]%}%1{➜%} ) %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"
```

# tmux

Install tmux plugin manager
```sh
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Run install command: Prefix (ctrl + b) + shift i (I)

