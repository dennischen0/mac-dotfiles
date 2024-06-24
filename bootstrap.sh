#!/usr/bin/env zsh

cd "$(dirname "${(%):-%N}")";

git pull origin main;

function install_oh_my_zsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)";
}

function install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"}
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
	source ~/.zshrc;


}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt;
	fi;
fi;
unset doIt;