#!/bin/bash

OPTIND=1

DPI=100
VERBOSE=0
QUIET=0
LOGFILE=/tmp/conforg.log
DEFAULT_CONFORG_DIR=$HOME/.dot-config
DOT_DIR=$DEFAULT_CONFORG_DIR/contrib
GITIGNORE_IN=./contrib/gitignore
GITIGNORE_OUT=$HOME/.gitignore_global
PASSWORD_STORE=false
ALARM_SOUND=clock-chimes-daniel_simon.wav
MINIMAL_INSTALL=false

INSTALL_ARGS="$*"

function show_help() {
  echo "-v Show detailed logs"
  echo "-q Supress all warnings, also unset -v"
  echo "-d <DPI> Set the DPI value in .Xresources (default to be 100)."
  echo "         A rule of thumb is to set this value such that 11pt font looks nice."
  echo "-f <file> Set log file"
  echo "-c <path> Set conforg path"
  echo "-g <file> Set global gitignore file"
  echo "-a <file> Set which alarm sound to use under contrib/sounds"
  echo "-p Plain install (do not set up credentials with pass)"
  echo "-m Minimal install (for servers, without additional bells and whistles)"
}

while getopts "h?vd:a:f:qc:g:pm" opt; do
  case "$opt" in
    h|\?)
      show_help
      exit 0
      ;;
    v)
      VERBOSE=1;;
    a)
      ALARM_SOUND=$OPTARG;;
    d)
      DPI=$OPTARG;;
    f)
      LOGFILE=$OPTARG;;
    q)
      QUIET=1;;
    c)
      DEFAULT_CONFORG_DIR=$OPTARG;;
    g)
      GITIGNORE_OUT=$OPTARG;;
    p)
      PASSWORD_STORE=false;;
    m)
      MINIMAL_INSTALL=true;;
    : )
      echo "Option -"$OPTARG" requires an argument." >&2
      exit 1;;
  esac
done

if [[ $QUIET != 0 ]]; then
  VERBOSE=0
fi

function box_out() {
  if [[ $VERBOSE == 0 ]]; then
    return
  fi
  local s="$*"
  tput setaf 3
  echo " -${s//?/-}-
| ${s//?/ } |
| $(tput setaf 4)$s$(tput setaf 3) |
| ${s//?/ } |
 -${s//?/-}-"
  tput sgr 0
}

function box_warn()
{
  if [[ $QUIET != 0 ]]; then
    return
  fi
  local s=("$@") b w
  for l in "${s[@]}"; do
    ((w<${#l})) && { b="$l"; w="${#l}"; }
  done
  tput setaf 5
  echo "  **${b//?/*}**"
  for l in "${s[@]}"; do
    printf '  * %s%*s%s *\n' "$(tput setaf 6)" "-$w" "$l" "$(tput setaf 5)"
  done
  echo "  **${b//?/*}**"
  tput sgr 0
}

box_out "Greetings. Please make sure you cloned the repo under $DEFAULT_CONFORG_DIR."

box_out "Detecting your OS.."

PLATFORM='unknown'
UNAMESTR=`uname`
if [[ "$UNAMESTR" == 'Linux' ]]; then
   PLATFORM='linux'
elif [[ "$UNAMESTR" == 'Darwin' ]]; then
   PLATFORM='mac'
elif [[ "$UNAMESTR" == 'FreeBSD' ]]; then
   PLATFORM='freebsd'
fi

if [[ $VERBOSE != 0 ]]; then
  echo "+ Running on $PLATFORM"
fi

# Setup a single entry
function setup_entry {
entry=$1
home_entry=$2
echo "-----------------------------------"
echo Setting up $entry..
if [ -e $home_entry/"$entry" ];
then
  if [ -L $home_entry/"$entry" ];
  then
    if [ "$(readlink $home_entry/$entry)" = $DOT_DIR/"$entry" ];
    then
      echo "Target $home_entry/$entry symlink already setup! Skipping.."
      return 0
    else
      echo "Target $home_entry/$entry symlink exists but pointing to another file!"
      echo " >> $home_entry/$entry is pointing to $(readlink $home_entry/$entry)"
      echo " >> But I am trying to setup symlink to $DOT_DIR/$entry"
      while true; do
        read -p "Do you wish to force re-linking this entry?" yn
        case $yn in
          [Yy]* ) rm -f $home_entry/"$entry"; ln -s $DOT_DIR/"$entry" $home_entry/"$entry"; echo "Done."; break;;
          [Nn]* ) echo Skipping..; break;;
          * ) echo "Please answer [y]es or [n]o.";;
        esac
      done
    fi
  else
    echo "Target $home_entry/$entry exists and is not a symlin!"
    echo "Please check out that file, make your decisions, and re-run this script."
    while true; do
      read -p "Do you wish to skip this one and continue installing the rest?" yn
      case $yn in
        [Yy]* ) echo Skipping..; break;;
        [Nn]* ) echo Exiting..; exit 1;;
        * ) echo "Please answer [y]es or [n]o.";;
      esac
    done
  fi
else
  if [ -L $home_entry/"$entry" ];
  then
    echo "Target $home_entry/$entry exists as a broken symlink!"
    echo " >> $home_entry/$entry is pointing to $(readlink $home_entry/$entry)"
    read -p "Force re-linking this entry to $DOT_DIR/$entry?" yn
    while true; do
      case $yn in
        [Yy]* ) rm -f $home_entry/"$entry"; ln -s $DOT_DIR/"$entry" $home_entry/"$entry"; echo "Done."; break;;
        [Nn]* ) echo Skipping..; break;;
        * ) echo "Please answer [y]es or [n]o.";;
      esac
    done
  else
    ln -s $DOT_DIR/"$entry" $home_entry/"$entry"
    echo "Done."
  fi
  return
fi
}

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

box_out "Setting up.."

setup_entry powerlevel9k $HOME/.oh-my-zsh/custom/themes
setup_entry powerlevel10k $HOME/.oh-my-zsh/custom/themes
