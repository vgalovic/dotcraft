# Set SYSTEMC path
set -gx SYSTEMC /usr/local/systemc
set -gx LD_LIBRARY_PATH /usr/local/systemc/lib $LD_LIBRARY_PATH

# Editor and pager
set -gx EDITOR (which nvim)
set -gx MANPAGER "nvim +Man!"
