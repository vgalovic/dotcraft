function fzf_theme
    set -l theme $argv[1]

    if test -z "$theme"
        echo "Usage: fzf_theme <moonfly|catppuccin|oldworld>"
        return 1
    end

    switch $theme
        case moonfly
            set -x FZF_DEFAULT_OPTS "
                --color=bg:#080808,fg:#bdbdbd
                --color=prompt:#cf87e8,border:#74b2ff
                --color=spinner:#79dac8,header:#8cc85f
                --color=info:#36c692,marker:#ff5d5d
                --color=pointer:#ff5189,selected-bg:#b2ceee,selected-fg:#080808
                --color=hl:#80a0ff,hl+:#74b2ff
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
        case '*'
            echo "Unknown theme: $theme"
            echo "Available: moonfly, catppuccin, oldworld"
            return 1
    end
end
