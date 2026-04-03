for file in ~/.config/shell/shared/*.sh; do
    source "$file"
done

for file in ~/.config/shell/zsh/*.zsh; do
    source "$file"
done
