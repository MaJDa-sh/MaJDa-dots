if status is-interactive
    # Commands to run in interactive sessions can go here
end

function fish_greeting
end

fish_vi_key_bindings

set -gx PATH $HOME/.npm-global/bin $PATH

set -gx ASDF_DATA_DIR $HOME/.asdf
set -gx PATH $ASDF_DATA_DIR/shims $PATH

set -U fish_color_normal normal
set -U fish_color_command normal
set -U fish_color_autosuggestion brblack
set -U fish_color_param normal
set -U fish_color_comment brblack
set -gx EDITOR nvim

