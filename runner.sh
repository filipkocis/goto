#!/bin/bash

# runner script for 'goto'
# this script should be sourced by the shell in order for the 'cd' command to work
# it executes 'goto.sh' and decides what to do based on the returned output

GOTO_SCRIPT_PATH=~/.config/goto/goto.sh

function goto_script_runner() {
  local output=$($GOTO_SCRIPT_PATH $@; echo $?) 
  local exit_status=$(echo "$output" | tail -n 1)

  # Exit if output is empty, or is a single line
  if [ -z "$output" ]; then
    echo "Error: No output"
    return 1
  elif [[ $(echo "$output" | wc -l) -eq 1 ]]; then
    return $exit_status
  fi

  local first_line=$(echo "$output" | head -n 1)
  local path_line=$(echo "$output" | tail -n 2 | head -n 1)

  # Manage the output
  if [ "$first_line" == "path" ]; then
    cd -P "$path_line"
  else
    local body=$(echo "$output" | head -n -1)
    if [ ! -z "$body" ]; then 
      echo "$body"
    fi
  fi

  unset -f goto_script_runner
  return $exit_status
}

goto_script_runner $@
