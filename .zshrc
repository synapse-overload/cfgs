# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000000
SAVEHIST=10000000
unsetopt beep
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/razvan/.zshrc'

autoload -Uz compinit
compinit

# End of lines added by compinstall
if [ "$TERM" = "linux" ]; then
	AGKOZAK_CMD_EXEC_TIME=1
	AGKOZAK_COLORS_EXIT_STATUS=red
	AGKOZAK_COLORS_USER_HOST=green
	AGKOZAK_COLORS_PATH=blue
	AGKOZAK_COLORS_BRANCH_STATUS=yellow
	AGKOZAK_COLORS_PROMPT_CHAR=default      # Default text color
	AGKOZAK_COLORS_CMD_EXEC_TIME=default    # Default text color
	AGKOZAK_COLORS_VIRTUALENV=green
	source /home/razvan/.config/agkozak-zsh-prompt/agkozak-zsh-prompt.plugin.zsh
	#bindkey "\e[1~" beginning-of-line
	#bindkey "\e[4~" end-of-line
	#bindkey "\eH" backward-kill-word
	#bindkey "\e[3~" kill-word
	#bindkey "\e[C" forward-word
	#bindkey "\e[D" backward-word
else
	ZSH_THEME=powerlevel10k
	# powerlevel10k theme for fancy shmancy command line stuff
	source /home/razvan/powerlevel10k/powerlevel10k.zsh-theme
	# key bindings for razvan's convenience
	bindkey  "^[[H"   beginning-of-line
	bindkey  "^[[F"   end-of-line
	bindkey  "^[[3~"  delete-char
	bindkey  "^[[3;5~" kill-word
	bindkey "^H" backward-kill-word
	bindkey "^[[1;5C" forward-word
	bindkey "^[[1;5D" backward-word
fi
# Luate de pe reddit https://www.reddit.com/r/zsh/comments/eblqvq/del_pgup_and_pgdown_input_in_terminal/

autoload -Uz up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

bindkey '^?'      backward-delete-char          # bs         delete one char backward
bindkey '^[[3~'   delete-char                   # delete     delete one char forward
bindkey '^[[H'    beginning-of-line             # home       go to the beginning of line
bindkey '^[[F'    end-of-line                   # end        go to the end of line
bindkey '^[[1;5C' forward-word                  # ctrl+right go forward one word
bindkey '^[[1;5D' backward-word                 # ctrl+left  go backward one word
bindkey '^H'      backward-kill-word            # ctrl+bs    delete previous word
bindkey '^[[3;5~' kill-word                     # ctrl+del   delete next word
bindkey '^J'      backward-kill-line            # ctrl+j     delete everything before cursor
bindkey '^[[D'    backward-char                 # left       move cursor one char backward
bindkey '^[[C'    forward-char                  # right      move cursor one char forward
bindkey '^[[A'    up-line-or-beginning-search   # up         prev command in history
bindkey '^[[B'    down-line-or-beginning-search # down       next command in history

#---

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# New Razvan theme
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k_themes/p10k-rainbow.zsh

# exports so that man works fine, personal scripts are included and default editor is VIM
export PATH=~/Scripts:${PATH}
export EDITOR=vim
export PAGER='less -R'
export CALIBRE_USE_DARK_PALETTE=1
alias ll='ls -lart --color'
alias l='ls -la --color'
plugins=(colored-man-pages)
userid=$(id -u)
if [[ $userid -ne 0 ]]; then
	export DOCKER_HOST=unix://${XDG_RUNTIME_DIR}/docker.sock
fi
case $TERM in 
	xterm*)
		precmd() { print -Pn "\e]2;$PWD\a" }
	;;
esac

function set-title(){
	print -Pn "\e]2;$@\a"
}
source /home/razvan/.aliases
setopt RM_STAR_SILENT

[ -f /usr/share/fzf/shell/key-bindings.zsh ] && source /usr/share/fzf/shell/key-bindings.zsh
[ -f /usr/share/fzf/shell/completion.zsh ] && source /usr/share/fzf/shell/completion.zsh

export PATH=/usr/lib64/ccache:/home/razvan/.cargo/bin:/home/razvan/go/bin:${PATH}
setopt interactivecomments
source ~/.zshrc-keyboard
source /home/razvan/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
export LIBVA_DRIVER_NAME=iHD
zstyle ':completion:*:*:git:*' script ~/.git-completion.bash
fpath=(~/.zsh $fpath)


function new_proj()
{
    local proj_name=$1
    if [ -z "${proj_name}" ]; then
	echo "Please specify the project name as first argument."
	return 1
    fi

    mkdir ${proj_name}
    cd ${proj_name}

    cat <<EOF > CMakeLists.txt
cmake_minimum_required(VERSION 3.19)
project(${proj_name} VERSION 1.0.0)
add_executable(${proj_name} main.cc)
EOF

    cat <<EOF > main.cc
#include <iostream>

int main(int, char**) {
    std::cout << "Hello, world!\n";

}
EOF

    cat <<'EOF' > Makefile
.PHONY: build

build:
	-mkdir build
	-cmake -S . -B ./build -DCMAKE_BUILD_TYPE=Debug -DCMAKE_EXPORT_COMPILE_COMMANDS=True -G Ninja
	-ln -s ./build/compile_commands.json compile_commands.json
	cmake --build build -j $$(nproc)
EOF
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
