# SYSTEMC
set -gx SYSTEMC /usr/local/systemc
set -gx LD_LIBRARY_PATH /usr/local/systemc/lib $LD_LIBRARY_PATH

# Cargo
set -gx PATH $HOME/.cargo/bin $PATH

# User local bin
set -gx PATH $HOME/.local/bin $PATH

# NPM global
set -gx PATH $HOME/.npm-global/bin $PATH

# Editor and pager
set -gx EDITOR (which nvim)
set -gx MANPAGER "nvim +Man!"
