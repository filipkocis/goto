#!/bin/bash

VERSION="2.0.0-bash"
AUTHOR="Filip.llc"

GOTO_SAVED_PATHS=~/.config/goto/paths

if [ ! -d GOTO_SAVED_PATHS ]; then
  mkdir -p $GOTO_SAVED_PATHS
fi

APP_NAME="goto"

print_help() {
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
  exit 0
}
print_version() {
  echo $VERSION 
  exit 0
}
save() {
  shift
  if [ -z $1 ] ; then
    echo "Specify a name for the current directory"
    echo "Usage: $APP_NAME -s <name>"
    exit 1
  fi
  local name=$(pwd)
  echo saving \"$name\" as \"$1\"
  ln -s $name $GOTO_SAVED_PATHS/$1
  exit 0
}
delete() {
  shift
  if [ -z $1 ] ; then
    echo "Specify a directory name to delete"
    echo "Usage: $APP_NAME -d <name>"
    exit 1
  fi
  if [ ! -d $GOTO_SAVED_PATHS/$1 ] ; then
    echo "Directory \"$1\" does not exist"
    exit 1
  fi
  echo removing \"$1\"
  rm $GOTO_SAVED_PATHS/$1
  exit 0
}
go_to() {
  local path=$(/bin/ls -1 $GOTO_SAVED_PATHS | fzf)
  if [ -z $path ] ; then
    exit 0
  fi
  echo "path"
  echo $GOTO_SAVED_PATHS/$path
  exit 0
}
list_saved() {
  ls -1 $GOTO_SAVED_PATHS | while read line ; do
    echo $line
  done
  exit 0
}

# goto
if [ -z $1 ] ; then 
  go_to
  exit 0
fi

# goto <name>
# if directory exists, match it with grep and echo the value
if [[ ! $1 == -* ]] ; then
  count=$(/bin/ls -1 $GOTO_SAVED_PATHS | grep $1 | wc -l)

  if [ $count -eq 0 ] ; then
    echo "Directory \"$1\" not found"
    exit 1
  fi
  
  if [ -e $GOTO_SAVED_PATHS/$1 ] ; then
    echo "path"
    echo $GOTO_SAVED_PATHS/$1
    exit 0
  elif [ $count -gt 1 ] ; then
    echo "Multiple directories found:"
    ls -1 $GOTO_SAVED_PATHS | grep $1
    exit 1
  fi

  echo "path"
  echo $GOTO_SAVED_PATHS/$(/bin/ls -1 $GOTO_SAVED_PATHS | grep $1)  
  exit 0
fi

# goto -X <name>
option=$1
case $option in
  -h) print_help      ;;
  -v) print_version   ;;
  -l) list_saved      ;;
  -s) save "$@"       ;;
  -d) delete "$@"     ;;
  *) print_help       ;;
esac
