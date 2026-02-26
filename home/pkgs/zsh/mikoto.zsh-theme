# Mikoto ZSH Theme
# Colored-cell prompt inspired by the Mikoto design language
# Each segment is a colored background block with contrasting text

# --- Palette (truecolor) ---
# Usage: %K{...} = background, %F{...} = foreground, %k%f = reset

_mikoto_segment() {
  local bg=$1 fg=$2 content=$3
  if [[ -n "$content" ]]; then
    echo -n "%K{$bg}%F{$fg} $content %f%k"
  fi
}

_mikoto_separator() {
  echo -n "%F{#4a4a52}─%f"
}

# --- Build prompt ---
_mikoto_prompt() {
  local exit_code=$?

  local p=""

  # Group 1: Username + Directory (related)
  p+="$(_mikoto_segment '#1c1c22' '#9CA3AF' '%n')"
  p+="$(_mikoto_segment '#06B6D4' '#ffffff' '%~')"

  # Group 2: Git info (related within group)
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    local git_info=""
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    if [[ -n "$branch" ]]; then
      git_info+="$(_mikoto_segment '#2563EB' '#ffffff' "$branch")"
    fi
    local changes=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
    if [[ "$changes" -gt 0 ]]; then
      git_info+="$(_mikoto_segment '#8B5CF6' '#ffffff' "*$changes")"
    fi
    if [[ -n "$git_info" ]]; then
      p+="$(_mikoto_separator)"
      p+="$git_info"
    fi
  fi

  # Group 3: Nix shell
  if [[ -n "$IN_NIX_SHELL" ]]; then
    p+="$(_mikoto_separator)"
    p+="$(_mikoto_segment '#22D3EE' '#0a0a0c' 'nix')"
  fi

  # Group 4: Error
  if [[ $exit_code -ne 0 ]]; then
    p+="$(_mikoto_separator)"
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
