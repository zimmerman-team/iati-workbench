if [ $UID -ne 0 ]
then
  PS1='\u:\w\$ '
else
  PS1='iati-engine \u:\w# '
fi

LESS=' -R '

alias do='ant'
alias ll='ls -alF'
alias la='ls -A'

# add command line autocompletion for ant targets (also for do alias)
_ant()
{
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  opts=`ant -p -q -f /root/build.xml | grep ^\  | cut -f 2 -d \ `

  COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
}
complete -F _ant ant
complete -F _ant do
