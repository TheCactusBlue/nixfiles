# Mikoto ZSH Theme
# Colored-cell prompt inspired by the Mikoto design language
# Each segment is a colored background block with contrasting text

# --- Palette (truecolor) ---
# Usage: %K{...} = background, %F{...} = foreground, %k%f = reset

_mikoto_segment() {
  local bg=$1 fg=$2 content=$3
  if [[ -n "$content" ]]; then
    echo -n "%K{$bg}%F{$fg} $content %f%k "
  fi
}

# --- Build prompt ---
_mikoto_prompt() {
  local exit_code=$?

  local p=""

  # Username: bg-light, text-secondary
  p+="$(_mikoto_segment '#1c1c22' '#9CA3AF' '%n')"

  # Directory: cyan, white
  p+="$(_mikoto_segment '#06B6D4' '#ffffff' '%~')"

  # Git branch: blue, white (conditional)
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      p+="$(_mikoto_segment '#2563EB' '#ffffff' "$branch")"
    fi

    # Git dirty: purple, white (conditional)
    local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$changes" -gt 0 ]]; then
      p+="$(_mikoto_segment '#8B5CF6' '#ffffff' "*$changes")"
    fi
  fi

  # Nix shell: cyan-bright, black (conditional)
  if [[ -n "$IN_NIX_SHELL" ]]; then
    p+="$(_mikoto_segment '#22D3EE' '#0a0a0c' 'nix')"
  fi

  # Error: magenta, white (conditional)
  if [[ $exit_code -ne 0 ]]; then
    p+="$(_mikoto_segment '#EC4899' '#ffffff' "!$exit_code")"
  fi

  # Newline + arrow
  p+=$'\n'
  if [[ $exit_code -ne 0 ]]; then
    p+="%F{#EC4899}❱%f "
  else
    p+="%F{#2563EB}❱%f "
  fi

  echo -n "$p"
}

setopt PROMPT_SUBST
PROMPT='$(_mikoto_prompt)'
RPROMPT=''
