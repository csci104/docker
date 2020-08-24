# Convenience

# remove colors from ls command and add / to directories
alias ls="ls -p --color=none"

alias la="ls -la"

# Change shell to ignore hostname
export PS1="\u@docker:\w$ "

# Go to work directory
if [[ -s /work ]]
then
        cd /work
fi

