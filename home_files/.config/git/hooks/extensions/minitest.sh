#! /usr/bin/env bash

# Label: RSpec Dotfile
# Description: Detect RSpec dotfile.

# Label: RSpec Focus
# Description: Detect RSpec focus.
minitest_focus() {
  _scan_code "[test]" "Focus detected" 'test.rb$' '\sfocus\s'
}
export -f minitest_focus
