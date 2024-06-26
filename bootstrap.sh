#!/usr/bin/env zsh

cd "$(dirname "${(%):-%N}")";
git pull origin main;

function install_oh_my_zsh() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
    else
        echo "Oh My Zsh is already installed.";
    fi

    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "Installing Powerlevel10k theme...";
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    else
        echo "Powerlevel10k theme is already installed.";
    fi
}

function install_homebrew() {
    if ! which brew > /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
        eval "$(/opt/homebrew/bin/brew shellenv)";
    else
        echo "Homebrew is already installed.";
    fi
}

function doIt() {
    read "runBrewBundleOnly?Do you only want to run 'brew bundle'? (y/n) ";
    echo "";
    if [[ $runBrewBundleOnly =~ ^[Yy]$ ]]; then
        brew bundle;
        return; # Exit after running brew bundle if that's the only requested action
    fi
    
    read "reply?This may overwrite existing files in your home directory. Are you sure? (y/n) ";
	echo "";
    if [[ ! $reply =~ ^[Yy]$ ]]; then
        return; # Exit early if the answer is not yes
    fi

    install_oh_my_zsh;
    install_homebrew;
    brew bundle;

    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude ".gitignore" \
        --exclude "docs/" \
        --exclude "Brewfile" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms --ignore-existing . ~;
}

doIt;