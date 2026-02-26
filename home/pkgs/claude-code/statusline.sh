input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name')
dir=$(basename "$(echo "$input" | jq -r '.workspace.current_dir')")
context_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0 | floor')
branch=$(echo "$input" | jq -r '.workspace.git.branch // empty')

# Mikoto-style segment builder: colored bg cells with contrasting text
# Usage: segment "r;g;b" "r;g;b" "content" (bg rgb, fg rgb)
segment() { printf '\033[48;2;%sm\033[38;2;%sm %s \033[0m' "$1" "$2" "$3"; }
sep() { printf '\033[38;2;74;74;82m─\033[0m'; }

out=""
out+="$(segment '28;28;34' '156;163;175' "$model")"
out+="$(segment '6;182;212' '255;255;255' "$dir")"
out+="$(sep)"
out+="$(segment '139;92;246' '255;255;255' "$context_pct%")"
[ -n "$branch" ] && out+="$(sep)$(segment '37;99;235' '255;255;255' "$branch")"
echo -e "$out"
