# Erase default preset bindings
for key in alt-h alt-j alt-k alt-l ctrl-h ctrl-j ctrl-k ctrl-d
    bind --erase --preset $key
end

# Custom bindings
bind alt-m '__fish_man_page'
bind alt-/ '__fish_list_current_token'
bind alt-r clear-screen
bind ctrl-d kill-line
bind ctrl-q delete-or-exit
