# GOTO
A simple bash script to move quickly between saved directories

## Setup

### Dependencies
You need to have `fzf` installed
```
sudo pacman -S fzf
```

### Installation
Extract the repo into a folder and run `install.sh`:
- copies the script into `~/.config/goto/`
- adds alias to `~/.bashrc` 

## Usage
- `goto -h` - Prints help
- `goto` - Opens a menu (fzf) to choose paths from
- `goto <name>` - CD into a given path. A part of the name can also be used (e.g. 'me' instead of 'home')
- `goto -s <name>` - Saves the current path
- `goto -d <name>` - Deletes a saved path
- `goto -l` - List saved directories
- `goto -v` - Prints version
