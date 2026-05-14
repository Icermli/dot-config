[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](/LICENSE)

# dot-config

Several config files for bash, zsh, neovim and others. Inspired by [https://github.com/xywei/dot-files](https://github.com/xywei/dot-files).

# download

```
$ git clone https://github.com/Icermli/dot-config.git
$ mv dot-config/ .dot-config
$ cd .dot-config
$ git submodule update --init --recursive
```

# dot-files
A bunch of dot files that work across different platforms.

# install
## Install Homebrew
Run the following command:
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install iTerm2 If Necessary
If you don’t have a true color terminal, install iTerm2 with homebrew:
```
brew install --cask iterm2
```

## Install A Nerd Font
I use Cascadia Code NF. To install it do:
```
brew tap homebrew/cask-fonts
```
And then do:
```
brew install --cask font-cascadia-code-nf
```
Then open iTerm2 settings with **CMD+**, and under **Profiles > Text** change the font to Cascadia Code NF

## Install Neovim
Run:
```
brew install neovim
```

## Install Ripgrep
Run:
```
brew install ripgrep
```

## Install Node
Run:
```
brew install node
```

## Then install all the dots
Run:
```
./check_deps.sh
./install.sh
```

## tmux
The .tmux.conf is a configuration file for tmux. To use, make a symlink of this file under $HOME.

See [this video](https://youtu.be/JXwS7z6Dqic) for more information about tmux.

### TPM

Tmux plugin manager (TPM) is used for tmux plugins, including Dracula. `install.sh`
bootstraps TPM into `$HOME/.tmux/plugins/tpm`; within tmux, press `Prefix I` to
install or update plugins.

## neovim
Neovim config lives in `contrib/config/nvim` and is symlinked to
`$HOME/.config/nvim` by `install.sh`. Plugins are managed by
[lazy.nvim](https://github.com/folke/lazy.nvim); start `nvim` once and Lazy will
bootstrap itself under Neovim's data directory.

A good resource for learning vim is Steve's [Learn Vimscript the Hard Way](http://learnvimscriptthehardway.stevelosh.com/).

## MacOS

Zsh is the primary shell config and is installed as `$HOME/.zshrc`. The `.bashrc`
here also works for MacOS. Just add

```bash
source $HOME/.bashrc
```
to `.bash_profile`
