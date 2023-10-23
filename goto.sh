#!/bin/bash

VERSION="1.0.0-bash"
AUTHOR="Filip.llc"

GOTO_SAVED_PATHS=~/.config/goto/paths/

if [ ! -d GOTO_SAVED_PATHS ]; then
  mkdir -p $GOTO_SAVED_PATHS
fi

APP_NAME="goto"

# functions have gts (goto script) prefix to avoid name collisions
gts_print_help() {
  echo Version: $VERSION
  echo Author: $AUTHOR
  echo "This script is used to go to a saved location"
  echo
  echo "$APP_NAME <name>           # go to directory <name>"
  echo "$APP_NAME <name/subir/..>  # go to nested directories in <name>"
  echo "$APP_NAME -s <name>        # save current directory as <name>"
  echo "$APP_NAME -d <name>        # delete saved directory <name>"
  echo "$APP_NAME -l               # list all saved directories"
  echo "$APP_NAME -h               # show help"
  echo "$APP_NAME -v               # show version"
  return 0
}
gts_print_version() {
  echo $VERSION 
  return 0
}
gts_save() {
  shift
  if [ -z $1 ] ; then
    echo "Specify a name for the current directory"
    echo "Usage: $APP_NAME -s <name>"
    return 1
  fi
  local name=$(pwd)
  echo saving \"$name\" as \"$1\"
  ln -s $name $GOTO_SAVED_PATHS/$1
  return 0
}
gts_delete() {
  shift
  if [ -z $1 ] ; then
    echo "Specify a directory name to delete"
    echo "Usage: $APP_NAME -d <name>"
    return 1
  fi
  if [ ! -d $GOTO_SAVED_PATHS/$1 ] ; then
    echo "Directory \"$1\" does not exist"
    return 1
  fi
  echo removing \"$1\"
  rm $GOTO_SAVED_PATHS/$1
  return 0
}
gts_go_to() {
  local path=$(/bin/ls -1 $GOTO_SAVED_PATHS | fzf)
  if [ -z $path ] ; then
    return 0
  fi
  cd -P $GOTO_SAVED_PATHS/$path
  return 0
}
gts_list_saved() {
  ls -1 $GOTO_SAVED_PATHS | while read line ; do
    echo $line
  done
  return 0
}

# goto
if [ -z $1 ] ; then 
  gts_go_to
  return 0
fi

# goto <name>
# if directory exists, match it with grep and cd to it
if [ ! $1 == -* ] ; then
  count=$(/bin/ls -1 $GOTO_SAVED_PATHS | grep $1 | wc -l)

  if [ $count -eq 0 ] ; then
    echo "Directory \"$1\" not found"
    return 1
  fi
  
  if [ -e $GOTO_SAVED_PATHS/$1 ] ; then
    cd -P $GOTO_SAVED_PATHS/$1
    return 0
  elif [ $count -gt 1 ] ; then
    echo "Multiple directories found:"
    ls -1 $GOTO_SAVED_PATHS | grep $1
    return 1
  fi

  cd -P $GOTO_SAVED_PATHS/$(/bin/ls -1 $GOTO_SAVED_PATHS | grep $1)  
  return 0
fi

# goto -X <name>
option=$1
case $option in
  -h) gts_print_help      ;;
  -v) gts_print_version   ;;
  -l) gts_list_saved      ;;
  -s) gts_save "$@"       ;;
  -d) gts_delete "$@"     ;;
  *) gts_print_help       ;;
esac
