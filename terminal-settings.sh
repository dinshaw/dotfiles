# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# Terminal & iTerm 2                                                          #
###############################################################################

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4


# Install my fav font for terminal
# osascript <<EOD
#   set theFontPath to "${HOME}/.dotfiles/fonts/Consolas.ttf"

#   set theFont to POSIX file theFontPath

#   tell application "Finder"
#     open theFont
#   end tell

#   tell application "Font Book"
#     activate
#     set theFontWindow to the first window
#   end tell

#   tell application "System Events"
#     tell process "Font Book"
#       tell window 1
#         tell group 1
#           click button "Install Font"
#         end tell
#       end tell
#       quit
#     end tell
#   end tell
# EOD

# Open Terminal.app with Homebrew
osascript <<EOD

tell application "Terminal"

  local allOpenedWindows
  local initialOpenedWindows
  local windowID
  set themeName to "Homebrew"
  set default settings to settings set themeName

end tell

EOD
