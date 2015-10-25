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

# Remove outdated versions from the cellar.
brew cleanup

# Link Sublime cli
ln -sfn /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin
# Install package control
curl -o ~/Library/Application\ Support/Sublime\ Text\ 3/Installed\ Packages/Package\ Control.sublime-package https://sublime.wbond.net/Package%20Control.sublime-package 

# Copy terminal preferences
#cp ./preferences/com.apple.Terminal.plist /Library/Preferences/

# Link Sublime to Dropbox
# ln -sf ~/Dropbox/Application\ Support/Sublime\ Text\ 3/Packages/User  ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
