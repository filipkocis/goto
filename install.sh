#!/bin/bash

# installation script for 'goto'
# you need to have 'install.sh' and 'goto.sh' in the same directory

GOTO_PATH=~/.config/goto
BASHRC_PATH=~/.bashrc
ALIAS=goto

# create full path if it doesn't exist
if [ ! -d GOTO_PATH ]; then
  mkdir -p $GOTO_PATH
fi

# copy script to path
if [ -e $GOTO_PATH/goto.sh ]; then
  echo "[INFO]: replacing goto.sh in $GOTO_PATH/"
else
  echo "[INFO]: copying goto.sh to $GOTO_PATH/"
fi
cp goto.sh $GOTO_PATH/goto.sh

# add alias to bashrc
LINE="alias ${ALIAS}=\"source $GOTO_PATH/goto.sh\""
if grep -q "$LINE" $BASHRC_PATH; then
  echo "[INFO]: alias already exists in bashrc"
elif grep "alias $ALIAS *=" $BASHRC_PATH | grep -v "^ *#"; then
  echo "[ERROR]: custom alias already exists in bashrc"
  exit 1
else
  echo "[INFO]: adding alias to bashrc"
  echo $LINE >> ~/.bashrc
fi

echo "[SUCCESS]: installation complete"
