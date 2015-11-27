#!/usr/bin/env bash
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

brew install ack
brew install git
brew install rbenv
brew install mysql
brew install imagemagick
brew install speedtest_cli
brew cask install --appdir="/Applications" firefox

# Remove outdated versions from the cellar.
brew cleanup

# Link Sublime cli
ln -sfn /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin
# Install package control
if [ ! -f ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package ]; then
    echo "Downloading Sublime package control"
	curl -o ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package https://sublime.wbond.net/Package%20Control.sublime-package
fi

# Link Sublime to Dropbox
## Remove the newly-created User dir
rm -rf ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User
## Symlink Dropbox version
ln -sf ~/Dropbox/Library/Application\ Support/Sublime\ Text\ 3/Packages/User  ~/Library/Application\ Support/Sublime\ Text\ 3/Packages

# Copy terminal preferences
cp ./preferences/com.apple.Terminal.plist ~/Library/Preferences/
# Copy keybsaord preferences
cp ./preferences/com.apple.HIToolbox.plist ~/Library/Preferences/

