# Dennis' dotfiles
![Screenshot of my shell prompt](docs/images/shell.png)

## Installation

**Warning:** If you want to give these dotfiles a try, you should first fork this repository, review the code, and remove things you don’t want or need. Don’t blindly use my settings unless you know what that entails. Use at your own risk!

### Using Git and the bootstrap script

You can clone the repository wherever you want. (I like to keep it in `~/workspace/mac-dotfiles`.) The bootstrapper script will pull in the latest version and copy the files to your home folder.

```bash
git clone https://github.com/dennischen0/mac-dotfiles.git && cd mac-dotfiles && source bootstrap.sh
```

To update, `cd` into your local `dotfiles` repository and then:

```bash
source bootstrap.sh
```

Alternatively, to update while avoiding the confirmation prompt:

```bash
set -- -f; source bootstrap.sh
```

### Git-free install

To install these dotfiles without Git:

```bash
cd; curl -#L https://github.com/dennischen0/mac-dotfiles/tarball/main | tar -xzv --strip-components 1 --exclude={README.md,LICENSE-MIT.txt} | ./bootstrap.sh
```

To update later on, just run that command again.

## Author

| ![Dennis Chen's Avatar](https://0.gravatar.com/avatar/b80f0f6f60482a0046509e30297f983b734f33dc35b888ecec07cf608ca445c8?size=70) |
|---|
| [Dennis Chen](https://dennischen.com/) |

## Thanks to…

* [Mathias Bynens](http://benalman.com/) and his [dotfiles repository](https://github.com/mathiasbynens/dotfiles)