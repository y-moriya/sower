#!/bin/bash
curl https://raw.githubusercontent.com/seebi/dircolors-solarized/master/dircolors.ansi-dark -o ~/.dircolors

cat <<EOF > ~/.bashrc
PS1="\[\e[31m\]\u\[\e[m\]@\[\e[32m\]\h\[\e[m\]:\[\e[36m\]\w\[\e[m\]\\$ "
umask 022

export LS_OPTIONS='--color=auto'
test -r ~/.dircolors && eval "\$(dircolors -b ~/.dircolors)" || eval "\$(dircolors -b)"
alias ls='ls \$LS_OPTIONS'
alias ll='ls \$LS_OPTIONS -alF'
alias l='ls \$LS_OPTIONS -lA'

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
EOF

source ~/.bashrc
chmod 755 sow.cgi
chmod 755 deploy.sh
