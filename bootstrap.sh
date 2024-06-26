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
    if ! command -v brew >/dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
        eval "$(/opt/homebrew/bin/brew shellenv)";
    else
        echo "Homebrew is already installed.";
    fi
}

function install_homebrew_apps() {
    # Path to the base Brewfile
    BASE_BREWFILE="./Brewfile"
    # Path to the MAS Brewfile
    MAS_BREWFILE="./Brewfile_mas"

    # Always install the base applications
    if [ -f "$BASE_BREWFILE" ]; then
        echo "Installing base applications..."
        brew bundle --file="$BASE_BREWFILE"
    else
        echo "Base Brewfile not found."
    fi

    # Workaround for checking if logged into the Mac App Store
    # Check for any installed MAS apps as a proxy for being logged in
    if mas list | grep -q '^[0-9]'; then
        echo "MAS apps detected. Assuming logged into the Mac App Store. Installing MAS applications..."
        if [ -f "$MAS_BREWFILE" ]; then
            brew bundle --file="$MAS_BREWFILE"
        else
            echo "MAS Brewfile not found."
        fi
    else
        echo "No MAS apps detected or unable to verify. Skipping MAS applications."
    fi
}

function doIt() {
    read "runBrewBundleOnly?Do you only want to run 'brew bundle'? (y/n) ";
    echo "";
    if [[ $runBrewBundleOnly =~ ^[Yy]$ ]]; then
        install_homebrew_apps;
        return; # Exit after running brew bundle if that's the only requested action
    fi
    
    read "reply?This may overwrite existing files in your home directory. Are you sure? (y/n) ";
	echo "";
    if [[ ! $reply =~ ^[Yy]$ ]]; then
        return; # Exit early if the answer is not yes
    fi

    install_oh_my_zsh;
    install_homebrew;
    install_homebrew_apps;

    rsync --exclude-from='.rsync-exclude' \
        -avh --no-perms --ignore-existing . ~;
}

doIt;