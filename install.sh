#!/bin/zsh

# variables
SETUP_DIR="${HOME}/dotfiles"
DEFAULT_ZSH_CUSTOM=${HOME}/.oh-my-zsh/custom

## create install directory
mkdir -p "${SETUP_DIR}"

setup_homebrew () {
  # Homebrew
  ## Install
  echo "Installing Brew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew analytics off

  ## Install packages
  brew install synology-drive
  brew install google-chrome
  brew install obsidian

  brew install jetbrains-toolbox
  brew install spotify

  brew install raycast
  brew install discord

  brew install git
  brew install maven
  brew install nvm
  brew install curl
  brew install wget
  brew install iterm2
  brew install bat
  brew install eza
  brew install jq
  brew install stow

  brew install nikitabobko/tap/aerospace

  # https://github.com/FelixKratz/JankyBorders
  brew tap FelixKratz/formulae
  brew install borders

  brew install fzf

  echo "Brew setup complete!"
}

setup_macos () {
  echo "Setup MacOS..."

  # Drag windows from anywhere
  defaults write -g NSWindowShouldDragOnGesture -bool true
  # Disable automatic capitalization
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
  # Use F1, F2, etc. keys as standard function keys
  defaults write -g com.apple.keyboard.fnState -bool true
  # Disable Spotlight shortcut
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{enabled = 0; value = {parameters = (32, 49, 1048576); type = standard};}"
  # Disable Search man Page Index in Terminal
  defaults write pbs NSServicesStatus -dict-add "com.apple.Terminal - Search man Page Index in Terminal - pasteboard" "{key_equivalent = \"\"; }"
  # Disable Suggested and Recent Apps in Dock
  defaults write com.apple.dock show-recents -bool false
  # Enable auto hide Dock
  defaults write com.apple.dock autohide -bool true
  # Disable workspace animation
  defaults write com.apple.dock workspaces-auto-swoosh -bool false

  echo "MacOS setup complete!"
}

setup_zsh() {
  echo "Setup Zsh..."

  if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  else
    "${ZSH}"/tools/upgrade.sh
  fi

  # install powerlevel10k
  if [[ ! -d "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/themes/powerlevel10k" ]]; then
    git clone https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/themes/powerlevel10k"
  else
    git -C "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/themes/powerlevel10k" pull
  fi

  # install zsh-autosuggestions
  if [[ ! -d "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-autosuggestions"
  else
    git -C "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-autosuggestions" pull
  fi

  # install zsh-syntax-highlighting
  if [[ ! -d "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
  else
    git -C "${ZSH_CUSTOM:-$DEFAULT_ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" pull
  fi
  echo "Zsh setup complete!"
}

setup_dotfiles() {
  git -C "${SETUP_DIR}" pull || git -C "${SETUP_DIR}" clone https://github.com/chrgue/dotfiles . --depth 1
  echo "Installing dotfiles..."
  # shellcheck disable=SC2035
  stow -d "${SETUP_DIR}" -R */
  echo "Dotfiles installed!"
}

setup_dotfiles