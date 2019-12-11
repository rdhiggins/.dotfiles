#!/bin/zsh

autoload -U colors
colors

setopt PROMPT_SUBST ; PS1='[%{$fg[magenta]%}%n%{$reset_color%}@%{$fg_bold[green]%}%m%{$reset_color%} %{$fg_bold[yellow]%}%~%{$reset_color%}]
[%{$fg_bold[cyan]%}%*%{$reset_color%}%{$fg_bold[red]%}$(__git_ps1 " (%s)")%{$reset_color%}] \$ '


#RPROMPT='%{$fg_bold[red]%}$(__git_ps1 " (%s)")%{$reset_color%}'
