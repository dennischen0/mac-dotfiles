#!/usr/bin/env zsh

cd "$(dirname "${(%):-%N}")";

git pull origin main;

function install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

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
		-avh --no-perms . ~;
}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
	doIt;
else
	read "reply?This may overwrite existing files in your home directory. Are you sure? (y/n) ";
	echo "";
	if [[ $reply =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;