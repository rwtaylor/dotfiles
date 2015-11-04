# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH

alias R='R --no-save'

python -mplatform | grep Darwin && alias ls="ls -G" || alias ls="ls --color"
