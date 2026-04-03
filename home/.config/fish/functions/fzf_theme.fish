function fzf_theme
  set -l theme $argv[1]

  if test -z "$theme"
      echo "Usage: fzf_theme <moonfly|catppuccin|oldworld|github_dark_tritanopia>"
      return 1
  end

  switch $theme
    case moonfly
      set -x FZF_DEFAULT_OPTS "\
        --color=bg:#080808,bg+:#262626,fg:#b2b2b2,fg+:#e4e4e4 \
        --color=border:#2e2e2e,gutter:#262626,spinner:#36c692,hl:#f09479 \
        --color=header:#80a0ff,info:#cfcfb0,pointer:#ff5189 \
        --color=marker:#f09479,prompt:#80a0ff,hl+:#f09479 \
        --multi
      "
    case catppuccin
      set -x FZF_DEFAULT_OPTS "
          --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
          --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
          --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
          --color=selected-bg:#45475a
          --multi
      "
    case oldworld
      set -x FZF_DEFAULT_OPTS "
          --color=bg:#161617,bg+:#3C3B3E,fg:#c9c7cd,fg+:#d3d1d7
          --color=hl:#ea83a5,hl+:#ED96B3
          --color=info:#90b99f,prompt:#aca1cf,header:#85b5ba
          --color=pointer:#9ca2cf,marker:#acb1d7,spinner:#b7aed5
          --color=selected-bg:#3C3B3E,selected-fg:#c9c7cd
          --multi
      "
    case github_dark_tritanopia
      set -x FZF_DEFAULT_OPTS "
        --color=fg:#8b949e,bg:#0d1117,hl:#ffffff
        --color=fg+:#c9d1d9,bg+:#111d2e,hl+:#ffa198
        --color=info:#d29922,prompt:#58a6ff,pointer:#a371f7
        --color=marker:#ff7b72,spinner:#6e7681,header:#343941
        --multi
      "
    case '*'
      echo "Unknown theme: $theme"
      echo "Available: moonfly, catppuccin, oldworld"
      return 1
  end
end
