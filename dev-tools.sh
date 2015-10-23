#!/usr/bin/env bash
# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

brew install ack
brew install git
brew install rbenv
brew install qt
brew install phantomjs
brew install mysql
brew install imagemagick
brew install speedtest_cli

# Remove outdated versions from the cellar.
brew cleanup

# Link Sublime to Dropbox
ln -sf ~/Dropbox/Application\ Support/Sublime\ Text\ 3/Packages/User  ~/Library/Application\ Support/Sublime\ Text\ 3/Packages
