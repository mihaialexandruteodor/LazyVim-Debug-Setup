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

### Copy the vanilla config to the nvim folder
```
mkdir ~/.config/nvim
cd ~/.config/nvim
open .
```

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

# LINUX QUALITY OF LIFE IMPROVEMENTS
I'll just put them here even if it's not 100% related to the current repo.

## Alias to search ZSH history
edit '~/.zshrc' and add
```
# Function to search history using grep
search () {
  # The "$@" variable passes all arguments received by the function to grep
  history 1 | grep --color=always "$@"
}
```

then reload the shell
```
source ~/.zshrc
```
## 🏷️ `search` Function Usage

| Command | Description | Example Output (Hypothetical) |
| :--- | :--- | :--- |
| `search <term>` | Searches your entire history for any line containing the specified term. | `2017  git config --global user.name "John Doe"` |
| `search "<phrase>"` | Searches for an exact phrase (useful for commands with spaces). **Note the quotes.** | `345  docker run -it ubuntu bash` |
| `search <term1> <term2>` | Searches history for lines containing **both** `term1` AND `term2`. | `123  sudo apt update && sudo apt upgrade` |
| `search -i <term>` | Performs a **case-insensitive** search (passes `-i` to `grep`). | `456  git status` |
| `search -E "(term1\|term2)"` | Uses extended regex to search for lines containing **either** `term1` OR `term2`. (Backslash escapes the pipe `\|` to prevent table breakage). | `789  ls -l` |

