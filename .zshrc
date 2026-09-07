# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set the theme (Defaults to robbyrussell if omitted)
ZSH_THEME="robbyrussell"

# --- Performance & Behavior Tweaks ---
# Uncomment below if pasting URLs gets messy or slow
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment below to enable command auto-correction
# ENABLE_CORRECTION="true"

# --- Plugins Setup ---
# Note: zsh-syntax-highlighting MUST be the final element in this list.
plugins=(
  git 
  sudo 
  copypath 
  zsh-autosuggestions 
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# --- User Configuration & Preferences ---
# Preferred editor setup
export EDITOR='nvim'
export VISUAL='nvim'

# --- Custom Study & School Aliases ---
alias r='run'
alias stats='python3 ~/Documents/Study/scripts/study_graph.py'
alias study='~/Documents/Study/scripts/study.sh'
alias study-stats='python3 ~/Documents/Study/scripts/study_graph.py'
alias c='clear'
alias i='sudo pacman -Syu'
alias zshconfig="nvim ~/.zshrc" # Changed from 'mate' to match your nvim workflow

# --- Modern C++26 Compilation and Execution Runner ---
function run() {
    if [ $# -eq 0 ]; then
        echo "Error: No C++ file provided."
        return 1
    fi

    local file="$1"
    # Strip the .cpp extension using Zsh parameter expansion
    local exe="${file%.cpp}"

    # Compile and run if compilation succeeds (Using bleeding-edge C++26)
    clang++ \
        -std=c++23 \
        -stdlib=libc++ \
        -Wall -Wextra -Wpedantic \
        -Wconversion -Wsign-conversion \
        -Wshadow -Wformat=2 \
        -O2 \
        "$file" -o "$exe" && "./$exe"
}

# --- Competitive Programming Template Initialization ---
function cf() {
    if [ $# -eq 0 ]; then
        echo "Error: Please specify a filename."
        return 1
    fi

    if [ ! -f "$1" ]; then
        cp ~/.cf_template.cpp "$1"
    fi

    nvim "$1"
}


# Added by Antigravity CLI installer
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
