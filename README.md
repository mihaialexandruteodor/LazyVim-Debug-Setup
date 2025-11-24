<p align="center"><img src="lazyvim.png" width="50%" /></p>

Debugging works out of the box in Omarchy LazyVim, luckily. Yes, even Java!

Open LazyVim with `Leader+Shift+n` or `nvim` in terminal
Press `x` to go to LazyExtra
Press `x` on lines ***Plugins/dap.core*** and ***Languages/lang.java***

You need a pom.xml, gradle.build or .git to debug
Open debug menu with `Leader+d`, b is to toggle breakpoint, c to launch/continue, but you also have a debug CLI!

## Brew installs

### Brew
``` 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### OpenJdk

``` 
brew install openjdk
```
Symlink in case `java -version` cannot locate runtime
``` 
sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk \ /Library/Java/JavaVirtualMachines/openjdk.jdk
```

### Nerd fonts (needed for special characters)

```
brew tap homebrew/cask-fonts
brew install --cask font-jetbrains-mono-nerd-font
```

# Bazzite install

### Install Neovim via Homebrew (preinstalled on Bazzite)
Be careful at output, you might need to chown on some folders but the output gives all the commands!
```
brew install neovim

```

### Copy the vanilla config to 
`~/.var/app/io.neovim.nvim/config/nvim`

### Launch Neovim
```
nvim
```

### OTHER
# Yazi on MAC
install with 
```
brew install yazi ffmpeg sevenzip jq poppler fd ripgrep fzf zoxide resvg imagemagick font-symbols-only-nerd-font
```

edit `.zshrc` and add

```
export ZOXIDE_DATA="$HOME/.local/share/zoxide"
eval "$(zoxide init zsh)"
```
to make zoxide work

to add themes

```
nvim ~/.config/yazi/theme.toml
```

and paste a theme [from here for example](https://github.com/catppuccin/yazi/blob/main/themes/mocha/catppuccin-mocha-blue.toml)
