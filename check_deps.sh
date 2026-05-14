#!/usr/bin/env bash

set -u

platform="unknown"
case "$(uname)" in
  Darwin) platform="darwin" ;;
  Linux) platform="linux" ;;
  FreeBSD) platform="freebsd" ;;
esac

required=(
  awk
  cat
  cc
  git
  fzf
  make
  nvim
  perl
  rg
  sed
  tmux
  zsh
)

optional=(
  aspell
  fc-list
  kitty
  mbsync
  msmtp
  newsboat
  pass
  ranger
  task
)

alternatives=(
  "python:python3 python"
  "imagemagick:magick convert"
)

case "$platform" in
  darwin)
    required+=(brew gls gdir gvdir)
    ;;
  linux)
    required+=(
      aplay
      dmenu
      dunst
      flash_window
      mpd
      systemctl
      xclip
      xrdb
      zathura
    )
    ;;
esac

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

check_command() {
  local cmd=$1
  if command_exists "$cmd"; then
    echo "Found $cmd"
    return 0
  fi

  echo "Can't find $cmd"
  return 1
}

check_alternative() {
  local name=${1%%:*}
  local candidates=${1#*:}
  local candidate

  for candidate in $candidates; do
    if command_exists "$candidate"; then
      echo "Found $name ($candidate)"
      return 0
    fi
  done

  echo "Can't find $name (tried: $candidates)"
  return 1
}

missing_required=()
missing_optional=()

echo "Checking conforg dependencies for $platform..."

for cmd in "${required[@]}"; do
  if ! check_command "$cmd"; then
    missing_required+=("$cmd")
  fi
done

for spec in "${alternatives[@]}"; do
  if ! check_alternative "$spec"; then
    missing_required+=("${spec%%:*}")
  fi
done

if (( ${#missing_required[@]} )); then
  echo "ERROR: Missing necessary dependencies for conforg:"
  printf '  %s\n' "${missing_required[@]}"
  exit 1
fi

for cmd in "${optional[@]}"; do
  if ! check_command "$cmd"; then
    missing_optional+=("$cmd")
  fi
done

if (( ${#missing_optional[@]} )); then
  echo "WARNING: Missing optional dependencies for conforg:"
  printf '  %s\n' "${missing_optional[@]}"
  echo "Minimal install works, but some features will malfunction."
  exit 2
fi

echo "Congratulations! All deps have been found."
echo "
  Note that this is just a preliminary check on executable commands,
  don't celebrate too early,
  you still have to take efforts to install correct fonts.
  "
