input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')

# Git info via CLI (not available in statusline JSON schema), cached to avoid lag
CACHE_FILE="/tmp/statusline-git-cache"
CACHE_MAX_AGE=5
cache_stale() {
  [ ! -f "$CACHE_FILE" ] || \
  [ $(($(date +%s) - $(stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0))) -gt $CACHE_MAX_AGE ]
}
if cache_stale; then
  if git rev-parse --git-dir > /dev/null 2>&1; then
    _branch=$(git branch --show-current 2>/dev/null)
    _staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
    _modified=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')
    _upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null)
    if [ -n "$_upstream" ]; then
      _ahead=$(git rev-list --count '@{upstream}..HEAD' 2>/dev/null || echo 0)
      _behind=$(git rev-list --count 'HEAD..@{upstream}' 2>/dev/null || echo 0)
    else
      _ahead=0; _behind=0
    fi
    echo "$_branch|$_staged|$_modified|$_ahead|$_behind" > "$CACHE_FILE"
  else
    echo "||||" > "$CACHE_FILE"
  fi
fi
IFS='|' read -r branch staged modified ahead behind < "$CACHE_FILE"

# Mikoto-style segment builder: colored bg cells with contrasting text
# Usage: segment "r;g;b" "r;g;b" "content" (bg rgb, fg rgb)
segment() { printf '\033[48;2;%sm\033[38;2;%sm %s \033[0m' "$1" "$2" "$3"; }
sep() { printf '\033[38;2;74;74;82m─\033[0m'; }

out=""
out+="$(segment '230;133;69' '156;163;175' "󰛄")"
out+="$(segment '28;28;34' '156;163;175' "$model")"
out+="$(segment '6;182;212' '255;255;255' "$dir")"
if [ -n "$branch" ]; then
  git_info="$branch"
  [ "$ahead" -gt 0 ] 2>/dev/null && git_info+=" ↑$ahead"
  [ "$behind" -gt 0 ] 2>/dev/null && git_info+=" ↓$behind"
  out+="$(sep)$(segment '37;99;235' '255;255;255' " $git_info")"
  git_delta=""
  [ "$staged" -gt 0 ] 2>/dev/null && git_delta="+$staged"
  [ "$modified" -gt 0 ] 2>/dev/null && git_delta+="${git_delta:+ }~$modified"
  [ -n "$git_delta" ] && out+="$(segment '22;163;74' '255;255;255' "$git_delta")"
fi

out+="$(sep)"
out+="$(segment '139;92;246' '255;255;255' "$context_pct%")"
echo -e "$out"
