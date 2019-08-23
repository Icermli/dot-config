#!/bin/bash

OPTIND=1

DPI=100
VERBOSE=0
QUIET=0
LOGFILE=/tmp/conforg.log
DEFAULT_CONFORG_DIR=$HOME/.dot-config
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

box_out "Setting up directory structure.."
# in a subshell
(
  if [[ $VERBOSE != 0 ]]; then
    set -x;
  fi
  mkdir -p $HOME/.config;
  mkdir -p $HOME/.config/conforg;
  mkdir -p $HOME/.config/nvim;
  mkdir -p $HOME/.config/nvim/autoload;
  mkdir -p $HOME/.config/nvim/syntax;

  mkdir -p $HOME/cli-utils;
)

# Setup a single entry
function setup_entry {
entry=$1
source_entry=$2
home_entry=$3
echo "-----------------------------------"
echo Setting up $entry..
if [ -e $home_entry/"$entry" ];
then
  if [ -L $home_entry/"$entry" ];
  then
    if [ "$(readlink $home_entry/$entry)" = $source_entry/"$entry" ];
    then
      echo "Target $home_entry/$entry symlink already setup! Skipping.."
      return 0
    else
      echo "Target $home_entry/$entry symlink exists but pointing to another file!"
      echo " >> $home_entry/$entry is pointing to $(readlink $home_entry/$entry)"
      echo " >> But I am trying to setup symlink to $source_entry/$entry"
      while true; do
        read -p "Do you wish to force re-linking this entry?" yn
        case $yn in
          [Yy]* ) rm -f $home_entry/"$entry"; ln -s $source_entry/"$entry" $home_entry/"$entry"; echo "Done."; break;;
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
    read -p "Force re-linking this entry to $source_entry/$entry?" yn
    while true; do
      case $yn in
        [Yy]* ) rm -f $home_entry/"$entry"; ln -s $source_entry/"$entry" $home_entry/"$entry"; echo "Done."; break;;
        [Nn]* ) echo Skipping..; break;;
        * ) echo "Please answer [y]es or [n]o.";;
      esac
    done
  else
    ln -s $source_entry/"$entry" $home_entry/"$entry"
    echo "Done."
  fi
  return
fi
}

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

box_out "Setting up.."

setup_entry powerlevel9k $DEFAULT_CONFORG_DIR/contrib $HOME/.oh-my-zsh/custom/themes
setup_entry powerlevel10k $DEFAULT_CONFORG_DIR/contrib $HOME/.oh-my-zsh/custom/themes
setup_entry .zshrc $DEFAULT_CONFORG_DIR/contrib/zsh $HOME
setup_entry tmuxline $DEFAULT_CONFORG_DIR/contrib/cli-utils $HOME/cli-utils
setup_entry applescript $DEFAULT_CONFORG_DIR/contrib/cli-utils $HOME/cli-utils
setup_entry init.vim $DEFAULT_CONFORG_DIR/contrib/nvim $HOME/.config/nvim
setup_entry nvim-snips $DEFAULT_CONFORG_DIR/contrib/nvim $HOME/.config/nvim

box_out "Adding final touches.."

# Vim-plug
cp contrib/vim-plug/plug.vim $HOME/.config/nvim/autoload/plug.vim

# Vim-pyopencl
cp contrib/vim-pyopencl/pyopencl.vim $HOME/.config/nvim/syntax/pyopencl.vim

# Bash-insulter
cp contrib/bash-insulter $HOME/cli-utils/

if [[ $VERBOSE != 0 ]]; then
  set +o xtrace
  echo "+ Adding contents to .gitignore_global"
fi

# .gitignore_global
cat $GITIGNORE_IN/Global/*.gitignore >> $GITIGNORE_OUT
cat $GITIGNORE_IN/*.gitignore >> $GITIGNORE_OUT

# Python files are not to be ignored (e.g. __init__.py)
echo "!*.py" >> $GITIGNORE_OUT

# Jupyter notebook config
# requires: jupyterlab, jupytext
cd contrib/jupyter-nbconfig && sh ./setup.sh
cd ../..

# TPM (auto update if exists)
TPMPATH=$HOME/.tmux/plugins/tpm
if ! [ -d $TPMPATH/.git ]; then
  git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
  >> $LOGFILE 2>&1
else
  (cd $TPMPATH && git pull >> $LOGFILE 2>&1 && cd - >> $LOGFILE 2>&1)
fi

##################################################################
# minimal install ends here
##################################################################
if $MINIMAL_INSTALL; then
  box_warn "Warning: This is a minimal install, skipping extra setups."
  echo "+ Finishing up"
  finish_up
fi
