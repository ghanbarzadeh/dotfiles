# Dotfiles Setup Guide

This repository contains my personal dotfiles, managed using **GNU Stow**.  
The goal is to quickly bootstrap a new Linux system with a consistent shell,
tmux, and Neovim environment.

---

## Install requirements and clone repo

```bash
sudo apt install -y git stow tmux zsh neovim dircolors && \
git clone https://github.com/ghanbarzadeh/dotfiles.git ~/dotfiles && \
cd ~/dotfiles && stow .
```

## Shell setup (zsh + Oh My Zsh)

```bash
chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```
## Tmux setup (tmux + tpm)

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

Then start tmux and press ```Prefix + I```. This installs all tmux plugins defined in .tmux.conf.

## SSH key setup

### Generate the key

```bash
ssh-keygen -t ed25519 -C "agz1986@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

### Add key to github 

Copy the SSH public key to your clipboard and add to github account.

```bash
cat ~/.ssh/id_ed25519.pub
```